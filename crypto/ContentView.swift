//
//  ContentView.swift
//  crypto
//
//  Created by ImDung on 15/7/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.theme.background.ignoresSafeArea()
            VStack{
                Text("Accent Color")
                    .foregroundStyle(Color.theme.accent)
                
                Text("Secondary Color")
                    .foregroundStyle(Color.theme.secondaryText)
                
                Text("Red color")
                    .foregroundStyle(Color.theme.red)
                
                Text("Green color")
                    .foregroundStyle(Color.theme.green)
            }
        }
    }
}

#Preview {
    ContentView()
}
