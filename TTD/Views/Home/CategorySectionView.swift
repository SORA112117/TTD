// カテゴリセクション（持ち物・やること・予定・準備チェック）

import SwiftUI
import SwiftData

struct CategorySectionView: View {
    let category: TaskCategory
    let tasks: [TaskItem]
    let targetDate: Date
    let onToggle: (TaskItem) -> Void
    let onDelete: (TaskItem) -> Void
    let onAdd: (String, TaskCategory) -> Void

    var body: some View {
        Section {
            ForEach(tasks) { task in
                TaskRowView(task: task, onToggle: { onToggle(task) })
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            onDelete(task)
                        } label: {
                            Label("削除", systemImage: "trash")
                        }
                    }
            }

            // インライン追加フィールド
            InlineTaskInputView(category: category) { title in
                onAdd(title, category)
            }
        } header: {
            Label(category.displayName, systemImage: category.icon)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(category.color)
                .textCase(nil)
        }
    }
}
