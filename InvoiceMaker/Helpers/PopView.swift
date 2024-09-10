//
//  PopView.swift
//  InvoiceMaker
//
//  Created by Eze Chidera Paschal on 07/09/2024.
//

import SwiftUI

extension View {
    @ViewBuilder
    func popView<Content: View>(isPresented: Binding<Bool>, onDismiss: @escaping () -> (), @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .modifier(PopViewHelper(isPresented: isPresented, onDismiss: onDismiss, viewContent: content))
    }
}

fileprivate struct PopViewHelper<ViewContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var onDismiss: () -> ()
    
    @ViewBuilder var viewContent: ViewContent
    @State private var presentFullScreen: Bool = false
    @State private var animateView: Bool = false
    
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented, onDismiss: onDismiss, content: {
                viewContent
                    .visualEffect({ content, proxy in
                    content
                            .offset(y: offset(proxy))
                    })
                    .presentationBackground(.clear)
                    .task {
                        guard !animateView else { return }
                        withAnimation(.bouncy(duration: 0.4, extraBounce: 0.05)) {
                            animateView = true
                        }
                    }
            })
            .onChange(of: isPresented) { oldValue, newValue in
                if(newValue){
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    
                    
                    withTransaction(transaction) {
                        presentFullScreen = newValue
                    }
                } else {
                    
                }
                
            }
    }
    
    func offset(_ proxy: GeometryProxy) -> CGFloat {
        let viewHeight = proxy.size.height
        if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return animateView ? 0 : (viewHeight + screenSize.height) / 2
        }
        return 0
    }
}

