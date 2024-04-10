//
//  SplashScreenView.swift
//  iGoldProperty
//
//  Created by Mariem on 10/18/23.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Spacer()
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 500, height: 500)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(
                    Animation.easeIn(duration: 1.9)
                        .repeatCount(1)
                )
                .onAppear {
                    withAnimation {
                        isAnimating = true
                    }
                }
            Spacer()
        }
        .preferredColorScheme(.dark)
    }
}
