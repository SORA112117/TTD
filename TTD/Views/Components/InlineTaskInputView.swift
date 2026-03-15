// カテゴリ末尾に配置するインライン入力フィールド

import SwiftUI

struct InlineTaskInputView: View {
    let category: TaskCategory
    let onSubmit: (String) -> Void

    @State private var text: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: "plus.circle.fill")
                .font(.title3)
                .foregroundStyle(category.color.opacity(isFocused ? 1.0 : 0.5))
                .animation(.easeInOut(duration: 0.2), value: isFocused)

            TextField(category.placeholder, text: $text)
                .font(.body)
                .foregroundStyle(.primary)
                .focused($isFocused)
                .submitLabel(.done)
                .onSubmit(submit)
        }
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
    }

    private func submit() {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            isFocused = false
            return
        }
        onSubmit(trimmed)
        text = ""
        // 次のタスクを続けて入力できるようフォーカスを維持
    }
}
