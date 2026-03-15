// ホーム画面（メインタブ）

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @State private var viewModel = HomeViewModel()

    // 今日の未完了タスク
    @Query private var allTasks: [TaskItem]

    var todayIncompleteTasks: [TaskItem] {
        allTasks.filter {
            Calendar.current.isDate($0.targetDate, inSameDayAs: viewModel.today) &&
            !$0.isCompleted
        }
    }

    // 明日のタスク（カテゴリ別）
    var tomorrowTasks: [TaskItem] {
        allTasks.filter {
            Calendar.current.isDate($0.targetDate, inSameDayAs: viewModel.tomorrow)
        }
    }

    func tasks(for category: TaskCategory) -> [TaskItem] {
        tomorrowTasks
            .filter { $0.taskCategory == category }
            .sorted {
                // 予定カテゴリは時刻順、それ以外は追加順（createdAt）
                if category == .schedule,
                   let t1 = $0.scheduledTime, let t2 = $1.scheduledTime {
                    return t1 < t2
                }
                return $0.createdAt < $1.createdAt
            }
    }

    var tomorrowTaskCount: Int { tomorrowTasks.count }

    var body: some View {
        ZStack(alignment: .top) {
            NavigationStack {
                List {
                    // Section A: 今日の残タスク
                    if !todayIncompleteTasks.isEmpty {
                        Section {
                            ForEach(todayIncompleteTasks) { task in
                                TaskRowView(task: task) {
                                    viewModel.toggleComplete(task, allTasks: allTasks)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.deleteTask(task, context: context)
                                    } label: {
                                        Label("削除", systemImage: "trash")
                                    }
                                }
                            }
                        } header: {
                            Label("今日の残タスク", systemImage: "pin.fill")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                                .textCase(nil)
                        }
                    }

                    // Section B: 明日のタスク（カテゴリ別）
                    ForEach(TaskCategory.allCases, id: \.self) { category in
                        CategorySectionView(
                            category: category,
                            tasks: tasks(for: category),
                            targetDate: viewModel.tomorrow,
                            onToggle: { task in
                                viewModel.toggleComplete(task, allTasks: allTasks)
                            },
                            onDelete: { task in
                                viewModel.deleteTask(task, context: context)
                            },
                            onAdd: { title, cat in
                                viewModel.addTask(
                                    title: title,
                                    category: cat,
                                    targetDate: viewModel.tomorrow,
                                    context: context
                                )
                            }
                        )
                    }
                }
                .listStyle(.insetGrouped)
                .listSectionSpacing(8)
                .navigationTitle("明日の準備")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            TemplateView()
                        } label: {
                            Image(systemName: "list.bullet.rectangle")
                        }
                    }
                }
            }
            // 全完了バナー
            if viewModel.showAllDoneBanner {
                AllDoneBannerView(taskCount: tomorrowTaskCount)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .opacity
                        )
                    )
                    .zIndex(1)
                    .padding(.top, 8)
            }
        }
        // コンフェッティ（ConfettiSwiftUI導入後に有効化）
        // .confettiCannon(trigger: $viewModel.confettiTrigger, num: 60, radius: 350)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [TaskItem.self, TaskTemplate.self], inMemory: true)
}
