//
//  HomeViewModel.swift
//  crypto
//
//  Created by ImDung on 16/7/24.
//

import Foundation
class HomeViewModel : ObservableObject {
    @Published var allCoins : [CoinModel] = []
    @Published var portfoliosCoins : [CoinModel] = []
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.allCoins.append(DeveloperPreview.dev.coin)
            self.portfoliosCoins.append(DeveloperPreview.dev.coin)
        })
    }
    
}
