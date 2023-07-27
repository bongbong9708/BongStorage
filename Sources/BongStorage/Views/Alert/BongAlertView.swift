//
//  BongAlertView.swift
//  
//
//  Created by 이상봉 on 2023/07/19.
//

import SwiftUI

// MARK: - ㄴ BongAlertView
public struct BongAlertView: View {
    
    // 타이틀
    public var title: String = ""
    // 내용
    public var content: String = ""
    // 확인버튼
    public let confirmBtn: BongAlertButtonView
    // 취소버튼
    public let cancelBtn: BongAlertButtonView
    
    @State private var textField1Text = ""
    @State private var textField2Text = ""
    
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
            
            VStack(spacing: .zero) {
                
                VStack(spacing: .zero) {
                    // 타이틀
                    if "" != self.title {
                        Text(self.title)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                    }
                    
                    // 내용
                    Text(self.content)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    TextField("TextField 1", text: $textField1Text)
                    
                    SecureField("TextField 2", text: $textField2Text)
                }
                .frame(height: 99)
                
                Rectangle()
                    .frame(width: 300, height: 1)
                    .foregroundColor(.gray)
                
                
                // 버튼
                HStack(spacing: 0) {
                    self.cancelBtn
                    
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: 1, height: 50)
                    
                    self.confirmBtn
                }
                .frame(height: 50)
            }
            .frame(width: 300, height: 150)
            .background(Color.white)
            .cornerRadius(8)
        }
        .background(ClearBackground())
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

// MARK: - View Extension
extension View {
    public func bongAlert(isPresented:Binding<Bool>, bongAlert: @escaping () -> BongAlertView) -> some View {
        return modifier(BongAlertModifier(isPresent: isPresented, alert: bongAlert()))
    }
}
