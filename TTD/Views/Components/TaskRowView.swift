// タスク1行のUIコンポーネント

import SwiftUI

struct TaskRowView: View {
    let task: TaskItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: Spacing.md) {
            // チェックボックス
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .strokeBorder(
                            task.isCompleted ? task.taskCategory.color : Color.secondary.opacity(0.4),
                            lineWidth: 1.5
                        )
                        .fill(task.isCompleted ? task.taskCategory.color : Color.clear)
                        .frame(width: 22, height: 22)

                    if task.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.success, trigger: task.isCompleted)

            // タスクタイトル
            Text(task.title)
                .font(.body)
                .foregroundStyle(task.isCompleted ? .tertiary : .primary)
                .strikethrough(task.isCompleted, color: Color(.tertiaryLabel))
                .animation(.taskSpring, value: task.isCompleted)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 予定時刻（scheduleカテゴリのみ）
            if let time = task.scheduledTime {
                Text(time, style: .time)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }
}
