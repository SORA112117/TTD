// 全タスク完了時に表示するバナー

import SwiftUI

struct AllDoneBannerView: View {
    let taskCount: Int

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Text("🎉")
                .font(.title2)

            VStack(alignment: .leading, spacing: 2) {
                Text("準備完了！")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("全 \(taskCount) 件チェック完了")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.85))
            }

            Spacer()
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: Radius.large)
                .fill(Color.indigo)
                .shadow(color: .indigo.opacity(0.4), radius: 12, y: 4)
        )
        .padding(.horizontal, Spacing.md)
    }
}
