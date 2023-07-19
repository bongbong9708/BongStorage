//
//  BongAlertButtonView.swift
//  
//
//  Created by 이상봉 on 2023/07/19.
//

import SwiftUI

// MARK: - ㄴ BongAlertButtonType
public enum BongAlertButtonType {
    case CONFIRM
    case CANCEL
}

// MARK: - ㄴ BongAlertButtonView
public struct BongAlertButtonView: View {
    
    public typealias Action = () -> ()
    
    @Binding public var isPresented: Bool
    // 텍스트
    public var btnTitle: String = "확인"
    // 배경색
    public var btnColor: Color = .blue
    // 전달받은 액션
    public var action: Action
    // Alert 타입
    public var type : BongAlertButtonType
    
    public init(type: BongAlertButtonType,
                isPresented: Binding<Bool>,
                action: @escaping Action) {
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

