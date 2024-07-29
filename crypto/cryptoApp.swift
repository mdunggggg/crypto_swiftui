//
//  cryptoApp.swift
//  crypto
//
//  Created by ImDung on 15/7/24.
//

import SwiftUI

@main
struct cryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @State private var showLauchView : Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor : UIColor(Color.theme.accent)
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor : UIColor(Color.theme.accent)
        ]
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack{
                    HomeView()
                        .toolbar(.hidden)
                }
                .environmentObject(vm)
                
                ZStack {
                    if showLauchView {
                        LaunchView(showLaunchView: $showLauchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
                
            }
        }
    }
}
