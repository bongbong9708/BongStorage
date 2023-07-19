//
//  BongAlertView.swift
//  
//
//  Created by 이상봉 on 2023/07/19.
//

import SwiftUI

// MARK: - ㄴ BongAlertView
public struct BongAlertView: View {
    
    /// 얼럿 타이틀
    public var title: String = ""
    /// 얼럿 내용
    public var content: String = ""
    /// 확인버튼
    public let confirmBtn: BongAlertButtonView
    /// 취소버튼
    public let cancelBtn: BongAlertButtonView
    
    public init(title: String,
                content: String,
                confirmBtn: () -> BongAlertButtonView,
                cancelBtn: () -> BongAlertButtonView) {
        self.title = title
        self.content = content
        self.confirmBtn = confirmBtn()
        self.cancelBtn = cancelBtn()
    }
    
    public var body: some View {
        ZStack {
            // 배경
            Color.black
                .opacity(0.1)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: .zero) {
                // 타이틀 영역
                if "" != self.title {
                    Text(self.title)
                        .foregroundColor(.black)
                        .frame(height: 49)
                    
                    Rectangle()
                        .frame(width: 300, height: 1)
                        .foregroundColor(.gray)
                }
                
                
                // 버튼
                HStack(spacing: 0) {
                    self.cancelBtn
                    
                    self.confirmBtn
                }
                .frame(height: 50)
            }
            .frame(width: 300, height: "" != self.title ? 200 : 150)
            .background(Color.white)
            .cornerRadius(8)
        }
        .background(ClearBackground())
    }
}


// MARK: - ㄴ BongAlertButtonType
public enum BongAlertButtonType {
    case CONFIRM
    case CANCEL
}

// MARK: - ㄴ BongAlertButtonView
public struct BongAlertButtonView: View {
    
    public typealias Action = () -> ()
    
    @Binding public var isPresented: Bool
    /// 버튼 텍스트
    public var btnTitle: String = "확인"
    /// 버튼 배경색
    public var btnColor: Color = .blue
    /// 전달받은 액션
    public var action: Action
    /// Alert 타입(1. 확인, 2. 취소)
    public var type : BongAlertButtonType
    
    public init(type: BongAlertButtonType, isPresented: Binding<Bool>, action: @escaping Action) {
        self._isPresented = isPresented
        
        switch type {
        case .CONFIRM:
            self.btnTitle = "확인"
            self.btnColor = .blue
        case .CANCEL:
            self.btnTitle = "취소"
            self.btnColor = .red
        }
        
        self.action = action
        
        self.type = type
    }
    
    public var body: some View {
        
        Button {
            // 진동 효과
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            
            // 얼럿 닫아주기
            self.isPresented = false
            
            // 전달받은 액션 추가
            action()
        } label: {
            Text(btnTitle)
                .foregroundColor(self.btnColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

    }
}

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

// MARK: - Modifier
public struct BongAlertModifier: ViewModifier {
    
    @Binding var isPresent: Bool
    
    let alert: BongAlertView
    
    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresent) {
                // 모달 효과
                alert
            }
            .transaction { transaction in
                // 모달 애니메이션 없애기
                transaction.disablesAnimations = true
            }
    }
}

// MARK: - View 관련 확장
extension View {
    /// 1. 일반 얼럿
    public func bongAlert(isPresented:Binding<Bool>, bongAlert: @escaping () -> BongAlertView) -> some View {
        return modifier(BongAlertModifier(isPresent: isPresented, alert: bongAlert()))
    }
}
