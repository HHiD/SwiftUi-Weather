//
//  CustomButtonStyle.swift
//  WeatherForecast
//
//  Created by HongDi Huang on 2025/1/20.
//

import SwiftUI

struct PhysicalButtonStyle: ButtonStyle {
    var scale: CGFloat
    var animationDuration: Double
    var tapAreaPadding: CGFloat = 2 // Increase the tap area for easier tapping

    
    init(scale: CGFloat = 1.5, animationDuration: Double = 0.5) {
        self.scale = scale
        self.animationDuration = animationDuration
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(tapAreaPadding)
            .background(Color.blue)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: animationDuration), value: configuration.isPressed)
            .shadow(color: configuration.isPressed ? Color.gray.opacity(0.5) : Color.clear, radius: 5, x: 0, y: 5)
            .contentShape(Rectangle())
    }
}
