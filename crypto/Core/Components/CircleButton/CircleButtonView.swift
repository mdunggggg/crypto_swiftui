//
//  CircleButtonView.swift
//  crypto
//
//  Created by ImDung on 16/7/24.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName : String
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundStyle(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.25), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group{
        CircleButtonView(iconName: "info")
        CircleButtonView(iconName: "plus").colorScheme(.dark)
    }
}
