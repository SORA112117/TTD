// 通知管理サービス

import UserNotifications
import Foundation

final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    /// 通知許可をリクエスト
    func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let granted = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
        return granted ?? false
    }

    /// 朝のリマインダーを登録（毎日指定時刻）
    func scheduleMorningReminder(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()

        // 既存の通知を削除してから再登録
        center.removePendingNotificationRequests(withIdentifiers: ["morning-reminder"])

        let content = UNMutableNotificationContent()
        content.title = "明日の準備を確認しよう"
        content.body = "今日のリストをチェックして、スムーズな朝を迎えましょう！"
        content.sound = .default
        content.badge = nil

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "morning-reminder",
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    /// 夜の入力促し通知を登録（毎日指定時刻）
    func scheduleEveningReminder(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["evening-reminder"])

        let content = UNMutableNotificationContent()
        content.title = "明日の準備を登録しよう"
        content.body = "明日やること・持ち物を今のうちに登録しておきましょう"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "evening-reminder",
            content: content,
            trigger: trigger
        )
        center.add(request)
    }

    /// すべての通知をキャンセル
    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
