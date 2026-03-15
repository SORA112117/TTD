// テンプレート一覧画面

import SwiftUI
import SwiftData

struct TemplateView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \TaskTemplate.createdAt, order: .reverse) private var templates: [TaskTemplate]

    @State private var showCreateSheet = false
    @State private var selectedTemplate: TaskTemplate?

    var body: some View {
        NavigationStack {
            Group {
                if templates.isEmpty {
                    emptyState
                } else {
                    templateList
                }
            }
            .navigationTitle("テンプレート")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCreateSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreateSheet) {
                CreateTemplateView()
            }
        }
    }

    private var templateList: some View {
        List {
            ForEach(templates) { template in
                TemplateRowView(template: template)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            deleteTemplate(template)
                        } label: {
                            Label("削除", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(.insetGrouped)
    }

    private var emptyState: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("テンプレートがありません")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("よく使うタスクセットをテンプレートとして\n保存しておくと便利です")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
            Button("テンプレートを作成") {
                showCreateSheet = true
            }
            .buttonStyle(.bordered)
            .tint(.indigo)
        }
        .padding(Spacing.xl)
    }

    private func deleteTemplate(_ template: TaskTemplate) {
        withAnimation(.deleteEase) {
            context.delete(template)
        }
    }
}

// MARK: - テンプレート行
private struct TemplateRowView: View {
    let template: TaskTemplate

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "folder")
                    .foregroundStyle(.indigo)
                Text(template.name)
                    .font(.headline)
            }
            if !template.preview.isEmpty {
                Text(template.preview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Text("\(template.tasks.count)件のタスク")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - テンプレート作成シート
private struct CreateTemplateView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var templateName = ""
    @State private var tasks: [TemplateTask] = []
    @State private var newTaskTitle = ""
    @State private var selectedCategory: TaskCategory = .items

    var body: some View {
        NavigationStack {
            Form {
                Section("テンプレート名") {
                    TextField("例: 月曜の持ち物セット", text: $templateName)
                }

                Section("タスクを追加") {
                    // カテゴリ選択
                    Picker("カテゴリ", selection: $selectedCategory) {
                        ForEach(TaskCategory.allCases, id: \.self) { cat in
                            Label(cat.displayName, systemImage: cat.icon).tag(cat)
                        }
                    }
                    HStack {
                        TextField("タスク名", text: $newTaskTitle)
                            .submitLabel(.done)
                            .onSubmit(addTask)
                        Button("追加", action: addTask)
                            .disabled(newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }

                if !tasks.isEmpty {
                    Section("登録済みタスク（\(tasks.count)件）") {
                        ForEach(tasks) { task in
                            Label(task.title, systemImage: task.taskCategory.icon)
                                .foregroundStyle(task.taskCategory.color)
                        }
                        .onDelete { indexSet in
                            tasks.remove(atOffsets: indexSet)
                        }
                    }
                }
            }
            .navigationTitle("テンプレート作成")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { saveTemplate() }
                        .disabled(templateName.trimmingCharacters(in: .whitespaces).isEmpty || tasks.isEmpty)
                }
            }
        }
    }

    private func addTask() {
        let trimmed = newTaskTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        tasks.append(TemplateTask(title: trimmed, category: selectedCategory.rawValue))
        newTaskTitle = ""
    }

    private func saveTemplate() {
        let template = TaskTemplate(
            name: templateName.trimmingCharacters(in: .whitespaces),
            tasks: tasks
        )
        context.insert(template)
        dismiss()
    }
}

#Preview {
    TemplateView()
        .modelContainer(for: [TaskItem.self, TaskTemplate.self], inMemory: true)
}
