//
//  DetailView.swift
//  crypto
//
//  Created by ImDung on 24/7/24.
//

import SwiftUI

struct DetailView: View {
    
    let coin : CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        print("Init \(coin.name)")
    }
    
    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    DetailView(coin: DeveloperPreview.dev.coin)
}
