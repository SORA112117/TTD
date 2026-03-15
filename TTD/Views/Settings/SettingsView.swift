// 設定画面

import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    @State private var showResetConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                // 通知設定セクション
                Section {
                    Toggle("朝のリマインダー", isOn: $viewModel.morningReminderEnabled)
                        .tint(.indigo)
                        .onChange(of: viewModel.morningReminderEnabled) { _, enabled in
                            if enabled {
                                Task {
                                    await viewModel.requestNotificationPermission()
                                }
                            } else {
                                NotificationService.shared.cancelAll()
                            }
                        }

                    if viewModel.morningReminderEnabled {
                        DatePicker(
                            "通知時刻",
                            selection: $viewModel.morningReminderTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                } header: {
                    Text("通知")
                } footer: {
                    Text("設定した時刻に「明日の準備リスト」を確認する通知が届きます")
                }

                // バージョン情報
                Section("アプリ情報") {
                    HStack {
                        Text("バージョン")
                        Spacer()
                        Text(appVersion)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
}

#Preview {
    SettingsView()
}
