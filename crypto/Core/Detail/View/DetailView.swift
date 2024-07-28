//
//  DetailView.swift
//  crypto
//
//  Created by ImDung on 24/7/24.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var vm : DetailViewModel
   
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Init \(coin.name)")
    }
    
    var body: some View {
       Text("asd")
    }
}

#Preview {
    DetailView(coin: DeveloperPreview.dev.coin)
}
