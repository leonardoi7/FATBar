//
//  FATActionButtonView.swift
//  FATBar
//
//  Created by Leonardo Quintero on 29/06/2025.
//
import SwiftUI

struct FATActionButtonView: View {
    let button: FATActionButton
    private let buttonSize: CGFloat = 44
    private let wideButtonWidth: CGFloat = 88
    
    var body: some View {
        Button(action: button.action) {
            HStack(spacing: 6) {
                Image(systemName: button.icon)
                    .font(.system(size: 18, weight: .medium))
                
                if button.isWide, let title = button.title {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .lineLimit(1)
                }
            }
            .foregroundColor(.primary)
            .frame(
                width: button.isWide ? wideButtonWidth : buttonSize,
                height: buttonSize
            )
        }
        .buttonStyle(ScaledButtonStyle())
    }
}
