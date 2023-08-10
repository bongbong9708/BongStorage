//
//  BongSideMenu.swift
//  
//
//  Created by 이상봉 on 2023/08/10.
//

import SwiftUI

public struct BongSideMenu<Content>: View where Content: View {
    
    @Binding public var isPresented: Bool
    public var width: CGFloat
    public var content: Content
    
    @GestureState private var translation: CGFloat = .zero
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    public init(_ isPresented: Binding<Bool>, width: CGFloat, content: () -> Content) {
        self._isPresented = isPresented
        self.width = width
        self.content = content()
    }
    
    public var body: some View {
        HStack(alignment: .top) {
            Spacer()
            
            ZStack(alignment: .top) {
                Color.white
                
                VStack(spacing: 0) {
                    
                    Rectangle()
                        .frame(height: safeAreaInsets.top)
                        .foregroundColor(.white)
                    
                    self.content
                }
            }
            .frame(width: self.width)
        }
        .transition(.opacity.combined(with: .move(edge: .trailing)))
        .offset(x: translation)
        .gesture(
            DragGesture()
                .updating($translation) { value, state, _ in
                    if 0 <= value.translation.width {
                        let translation = min(self.width, max(-self.width, value.translation.width))
                        state = translation
                    }
                }
                .onEnded({ value in
                    if value.translation.width >= width/3 {
                        self.isPresented = false
                    }
                })
        )
    }
}

