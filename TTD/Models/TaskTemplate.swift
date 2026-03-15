// テンプレートのデータモデル（SwiftData）

import Foundation
import SwiftData

/// テンプレート内の個別タスク（Codableで保存）
struct TemplateTask: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var category: String // TaskCategory.rawValue

    var taskCategory: TaskCategory {
        TaskCategory(rawValue: category) ?? .todos
    }
}

@Model
final class TaskTemplate {
    var id: UUID
    var name: String
    var tasksData: Data  // [TemplateTask] をJSON encode して保存
    var createdAt: Date

    init(name: String, tasks: [TemplateTask] = []) {
        self.id = UUID()
        self.name = name
        self.tasksData = (try? JSONEncoder().encode(tasks)) ?? Data()
        self.createdAt = Date()
    }

    var tasks: [TemplateTask] {
        get {
            (try? JSONDecoder().decode([TemplateTask].self, from: tasksData)) ?? []
        }
        set {
            tasksData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    var preview: String {
        let titles = tasks.prefix(3).map { $0.title }
        return titles.joined(separator: "・")
    }
}
