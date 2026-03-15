// UI設計書に基づくデザイントークン定義

import SwiftUI

enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

enum Radius {
    static let small:  CGFloat = 8
    static let medium: CGFloat = 12
    static let large:  CGFloat = 16
    static let pill:   CGFloat = 999
}

extension Animation {
    /// タスク完了・追加などの標準スプリング
    static let taskSpring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    /// リスト挿入用スプリング
    static let insertSpring = Animation.spring(response: 0.4, dampingFraction: 0.8)
    /// 削除用
    static let deleteEase = Animation.easeInOut(duration: 0.25)
}
