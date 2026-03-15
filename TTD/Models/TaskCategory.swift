// カテゴリ定義

import SwiftUI

enum TaskCategory: String, CaseIterable, Codable {
    case items = "items"       // 持ち物
    case todos = "todos"       // やること
    case schedule = "schedule" // 予定
    case checklist = "checklist" // 準備チェック

    var displayName: String {
        switch self {
        case .items:     return "持ち物"
        case .todos:     return "やること"
        case .schedule:  return "予定"
        case .checklist: return "準備チェック"
        }
    }

    var icon: String {
        switch self {
        case .items:     return "bag"
        case .todos:     return "checkmark.square"
        case .schedule:  return "clock"
        case .checklist: return "list.clipboard"
        }
    }

    var placeholder: String {
        switch self {
        case .items:     return "持っていくものを追加..."
        case .todos:     return "明日やることを追加..."
        case .schedule:  return "予定を追加..."
        case .checklist: return "出発前に確認するものを追加..."
        }
    }

    var color: Color {
        switch self {
        case .items:     return .indigo
        case .todos:     return .blue
        case .schedule:  return .orange
        case .checklist: return .teal
        }
    }
}
