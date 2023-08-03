//
//  BongBottomSheet.swift
//  
//
//  Created by 이상봉 on 2023/08/03.
//

import SwiftUI


public struct BongBottomSheet<Content>: View where Content: View {
    
    @Binding public var isPresented: Bool
    public var height: CGFloat
    public var content: Content
    
    @GestureState private var translation: CGFloat = .zero
    
    public init(_ isPresented: Binding<Bool>, height: CGFloat, content: () -> Content) {
        self._isPresented = isPresented
        self.height = height
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: .zero) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 5)
                )
            
            self.content
                .frame(height: self.height)
        }
        .frame(height: self.height+30)
        .background(
            Rectangle()
                .fill(.white)
                .cornerRadius(20, corners: .topLeft)
                .cornerRadius(20, corners: .topRight)
                .edgesIgnoringSafeArea([.bottom, .horizontal])
        )
        .transition(.opacity.combined(with: .move(edge: .bottom)))
        .offset(y: translation)
        .gesture(
            DragGesture()
                .updating($translation) { value, state, _ in
                    if 0 <= value.translation.height {
                        let translation = min(self.height, max(-self.height, value.translation.height))
                        state = translation
                    }
                }
                .onEnded({ value in
                    if value.translation.height >= height/3 {
                        self.isPresented = false
                    }
                })
        )
    }
}
