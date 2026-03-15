// ホーム画面のViewModel

import SwiftUI
import SwiftData

@Observable
final class HomeViewModel {

    // MARK: - State

    /// 全タスク完了コンフェッティのトリガー（インクリメントで発火）
    var confettiTrigger: Int = 0
    /// 全完了バナーの表示制御
    var showAllDoneBanner: Bool = false

    // MARK: - 日付ユーティリティ

    /// 今日の日付（時刻なし）
    var today: Date {
        Calendar.current.startOfDay(for: Date())
    }

    /// 明日の日付（時刻なし）
    var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: today)!
    }

    /// 明日の表示文字列 例: "3月4日（水）"
    var tomorrowLabel: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月d日（E）"
        return formatter.string(from: tomorrow)
    }

    // MARK: - タスク操作

    /// タスクを追加する
    func addTask(
        title: String,
        category: TaskCategory,
        targetDate: Date,
        scheduledTime: Date? = nil,
        context: ModelContext
    ) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let task = TaskItem(
            title: title.trimmingCharacters(in: .whitespaces),
            category: category,
            scheduledTime: scheduledTime,
            targetDate: targetDate
        )
        withAnimation(.insertSpring) {
            context.insert(task)
        }
    }

    /// タスクの完了状態をトグルする
    func toggleComplete(_ task: TaskItem, allTasks: [TaskItem]) {
        withAnimation(.taskSpring) {
            task.isCompleted.toggle()
        }
        // 全完了チェック
        if task.isCompleted {
            let tomorrowTasks = allTasks.filter {
                Calendar.current.isDate($0.targetDate, inSameDayAs: tomorrow)
            }
            if !tomorrowTasks.isEmpty && tomorrowTasks.allSatisfy({ $0.isCompleted }) {
                triggerAllDone()
            }
        }
    }

    /// タスクを削除する
    func deleteTask(_ task: TaskItem, context: ModelContext) {
        withAnimation(.deleteEase) {
            context.delete(task)
        }
    }

    // MARK: - Private

    private func triggerAllDone() {
        // 少し遅延させてアニメーションが落ち着いてから演出
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.confettiTrigger += 1
            withAnimation(.spring()) {
                self.showAllDoneBanner = true
            }
            // 2.5秒後にバナーを非表示
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.3)) {
                    self.showAllDoneBanner = false
                }
            }
        }
    }
}
