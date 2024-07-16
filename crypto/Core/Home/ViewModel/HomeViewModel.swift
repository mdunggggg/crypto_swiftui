//
//  HomeViewModel.swift
//  crypto
//
//  Created by ImDung on 16/7/24.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    @Published var allCoins : [CoinModel] = []
    @Published var portfoliosCoins : [CoinModel] = []
    
    private let coinRepo = CoinDataRepository()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        coinRepo.$allCoins
            .sink {[weak self] returnedValue in
                self?.allCoins = returnedValue
            }
            .store(in: &cancellables)
    }
    
    
    
}
