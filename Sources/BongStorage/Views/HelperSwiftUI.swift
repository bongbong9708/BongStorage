//
//  SwiftUIView.swift
//  
//
//  Created by 이상봉 on 2023/07/19.
//

import SwiftUI

// MARK: - ㄴ 얼럿에서 투명한 배경
public struct ClearBackground: UIViewRepresentable {
    
    public func makeUIView(context: Context) -> UIView {
        
        let view = ClearBackgroundView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}

open class ClearBackgroundView: UIView {
    open override func layoutSubviews() {
        guard let parentView = superview?.superview else {
            print("ERROR: Failed to get parent view to make it clear")
            return
        }
        parentView.backgroundColor = .clear
    }
}

// MARK: - safeArea 길이 구하기
extension UIApplication {
    public var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}

public struct SafeAreaInsetsKey: EnvironmentKey {
    public static var defaultValue: EdgeInsets {
        (UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {

    public var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

extension UIEdgeInsets {

    public var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
