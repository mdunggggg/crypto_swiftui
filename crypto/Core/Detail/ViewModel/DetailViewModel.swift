//
//  DetailViewModel.swift
//  crypto
//
//  Created by ImDung on 28/7/24.
//

import Foundation
import Combine

class DetailViewModel : ObservableObject{
    private let coinDetailRepo : CoinDetailDataRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        coinDetailRepo = CoinDetailDataRepository(coinId: coin.id)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailRepo.$coinDetail.sink { value in
            print("Receive value \(String(describing: value))")
        }
        .store(in: &cancellables)
    }
    
}
