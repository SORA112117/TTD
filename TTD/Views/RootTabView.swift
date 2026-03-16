// タブバー（アプリのルートナビゲーション）

import SwiftUI
import SwiftData

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }

            TemplateView()
                .tabItem {
                    Label("テンプレート", systemImage: "list.bullet.rectangle")
                }

            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gearshape")
                }
        }
        .tint(.indigo)
    }
}

#Preview {
    RootTabView()
        .modelContainer(for: [TaskItem.self, TaskTemplate.self], inMemory: true)
}
