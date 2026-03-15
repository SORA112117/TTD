// 設定画面のViewModel

import SwiftUI

@Observable
final class SettingsViewModel {

    // MARK: - 通知設定（UserDefaultsに永続化）

    var morningReminderEnabled: Bool {
        didSet { UserDefaults.standard.set(morningReminderEnabled, forKey: Keys.morningEnabled) }
    }
    var morningReminderTime: Date {
        didSet {
            UserDefaults.standard.set(morningReminderTime, forKey: Keys.morningTime)
            updateMorningNotification()
        }
    }

    // MARK: - 初期化

    init() {
        let defaults = UserDefaults.standard
        self.morningReminderEnabled = defaults.bool(forKey: Keys.morningEnabled)
        if let saved = defaults.object(forKey: Keys.morningTime) as? Date {
            self.morningReminderTime = saved
        } else {
            // デフォルト 7:30
            var comps = DateComponents()
            comps.hour = 7
            comps.minute = 30
            self.morningReminderTime = Calendar.current.date(from: comps) ?? Date()
        }
    }

    // MARK: - 通知スケジュール更新

    func updateMorningNotification() {
        guard morningReminderEnabled else {
            NotificationService.shared.cancelAll()
            return
        }
        let comps = Calendar.current.dateComponents([.hour, .minute], from: morningReminderTime)
        NotificationService.shared.scheduleMorningReminder(
            hour: comps.hour ?? 7,
            minute: comps.minute ?? 30
        )
    }

    func requestNotificationPermission() async {
        let granted = await NotificationService.shared.requestAuthorization()
        if granted {
            morningReminderEnabled = true
            updateMorningNotification()
        }
    }

    // MARK: - Keys

    private enum Keys {
        static let morningEnabled = "morningReminderEnabled"
        static let morningTime    = "morningReminderTime"
    }
}
