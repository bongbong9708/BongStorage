//
//  BongSwipeAction.swift
//
//
//  Created by 이상봉 on 2023/10/11.
//

import SwiftUI

// MARK: - 1. SwipeState 스와이프 상태값
public enum BongSwipeState: Equatable {
    case untouched
    case swiped(String)
    case swipeEnd
}

// MARK: - 2. DzSwipeHorizontal 스와이프 버튼이 나타나는 위치
public enum SwipeHorizontal: Equatable {
    case leading
    case trailing
}

// MARK: - 3. DzSwipeActionModifier
struct BongSwipeActionModifier<SwipeButton: View>: ViewModifier {
    
    enum VisibleButton {
        case none
        case left
        case right
    }
    
    // 전달받아서 사용하는 값
    @Binding var state: BongSwipeState
    let edge: SwipeHorizontal
    let swipeButton: SwipeButton
    
    private let id: String = UUID().uuidString
    
    @State private var offset: CGFloat = 0
    @State private var oldOffset: CGFloat = 0
    @State private var visibleButton: VisibleButton = .none
    
    /**
     To detect if drag gesture is ended because of known issue that drag gesture onEnded not called:
     https://stackoverflow.com/questions/58807357/detect-draggesture-cancelation-in-swiftui
     */
    @GestureState private var dragGestureActive: Bool = false
    
    @State private var maxLeadingOffset: CGFloat = .zero
    @State private var minTrailingOffset: CGFloat = .zero
    
    @State private var contentWidth: CGFloat = .zero
    @State private var isDeletedRow: Bool = false
    /**
     For lazy views: because of measuring size occurred every onAppear
     */
    @State private var maxLeadingOffsetIsCounted: Bool = false
    @State private var minTrailingOffsetIsCounted: Bool = false
    
    // #. 생성자
    public init(state: Binding<BongSwipeState>,
                edge: SwipeHorizontal,
                swipeButton: SwipeButton) {
        _state = state
        self.edge = edge
        self.swipeButton = swipeButton
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            slidedMenu
                .zIndex(1)
            
            content
                .tag(id)
                .contentShape(Rectangle()) ///otherwise swipe won't work in vacant area
                .offset(x: offset)
                .measureSize {
                    contentWidth = $0.width
                }
                .gesture(
                    DragGesture(minimumDistance: 15, coordinateSpace: .local)
                        .updating($dragGestureActive) { value, state, transaction in
                            state = true
                        }
                        .onChanged { value in
                            let totalSlide = value.translation.width + oldOffset
                            
                            if (0 ... Int(maxLeadingOffset) ~= Int(totalSlide)) || (Int(minTrailingOffset) ... 0 ~= Int(totalSlide)) {
                                withAnimation {
                                    offset = totalSlide
                                }
                            }
                        }.onEnded { value in
                            withAnimation {
                                if visibleButton == .left,
                                   value.translation.width < -20 { ///user dismisses left buttons
                                    reset()
                                } else if visibleButton == .right,
                                          value.translation.width > 20 { ///user dismisses right buttons
                                    reset()
                                } else if offset >  25 || offset < -25 { ///scroller more then 50% show button
                                    if offset > 0 {
                                        visibleButton = .left
                                        offset = maxLeadingOffset
                                    } else {
                                        visibleButton = .right
                                        offset = minTrailingOffset
                                    }
                                    oldOffset = offset
                                    ///Bonus Handling -> set action if user swipe more then x px
                                } else {
                                    reset()
                                }
                            }
                        })
                .onChange(of: dragGestureActive) { dragActive in
                    if !dragActive,
                       visibleButton == .none {
                        withAnimation {
                            reset()
                        }
                    }
                    state = dragActive ? .swiped(id) : .untouched
                }
                .onChange(of: state) { value in
                    switch value {
                    case .swiped(let tag):
                        if id != tag,
                           visibleButton != .none {
                            withAnimation(.linear(duration: 0.3)) {
                                reset()
                            }
                            state = .untouched
                        }
                    case .swipeEnd:
                        if visibleButton != .none {
                            withAnimation(.linear(duration: 0.3)) {
                                reset()
                            }
                            state = .untouched
                        }
                    default:
                        break
                    }
                }
                .zIndex(3)
        }
        .frame(height: isDeletedRow ? 0 : nil, alignment: .top)
    }
    
    
    func reset() {
        visibleButton = .none
        offset = .zero
        oldOffset = .zero
    }
    
    var swipeButtonView: some View {
        swipeButton
            .measureSize {
                if edge == .trailing {
                    if !minTrailingOffsetIsCounted {
                        minTrailingOffset = (abs(minTrailingOffset) + $0.width) * -1
                    }
                } else {
                    if !maxLeadingOffsetIsCounted {
                        maxLeadingOffset = maxLeadingOffset + $0.width
                    }
                }
            }
            .onAppear {
                if edge == .trailing {
                    minTrailingOffsetIsCounted = true
                } else {
                    maxLeadingOffsetIsCounted = true
                }
            }
    }
    
    var slidedMenu: some View {
        HStack(spacing: .zero) {
            if edge == .leading {
                swipeButtonView
                    .offset(x: (-1 * maxLeadingOffset) + offset)
            }
            
            Spacer()
            
            if edge == .trailing {
                swipeButtonView
                    .offset(x: (-1 * minTrailingOffset) + offset)
            }
        }
    }
}

// MARK: - #. 사용시
extension View {
    public func bongSwipeAction<Content: View>(edge: SwipeHorizontal,
                                               state: Binding<BongSwipeState>,
                                               swipeButton: @escaping () -> Content) -> some View {
        
        return modifier(BongSwipeActionModifier(state: state, edge: edge, swipeButton: swipeButton()))
    }
}


