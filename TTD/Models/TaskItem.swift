// タスクのデータモデル（SwiftData）

import Foundation
import SwiftData

@Model
final class TaskItem {
    var id: UUID
    var title: String
    var category: String          // TaskCategory.rawValue で保存
    var scheduledTime: Date?      // 予定カテゴリのみ使用
    var isCompleted: Bool
    var targetDate: Date          // 対象日付（明日 or 今日）
    var sortOrder: Int            // セクション内の並び順
    var createdAt: Date

    init(
        title: String,
        category: TaskCategory,
        scheduledTime: Date? = nil,
        targetDate: Date,
        sortOrder: Int = 0
    ) {
        self.id = UUID()
        self.title = title
        self.category = category.rawValue
        self.scheduledTime = scheduledTime
        self.isCompleted = false
        self.targetDate = targetDate
        self.sortOrder = sortOrder
        self.createdAt = Date()
    }

    var taskCategory: TaskCategory {
        TaskCategory(rawValue: category) ?? .todos
    }
}
