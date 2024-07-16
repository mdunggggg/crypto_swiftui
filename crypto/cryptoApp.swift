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
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(vm)
        }
    }
}
