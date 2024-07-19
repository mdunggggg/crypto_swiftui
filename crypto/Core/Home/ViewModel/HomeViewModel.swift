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
    
    @Published var searchText = ""
    
    private let coinRepo = CoinDataRepository()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        
    }
    
    func addSubscribers() {
        $searchText
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true)
            .combineLatest(coinRepo.$allCoins)
            .map(filterCoins)
            .sink {[weak self] returnedValue in
                self?.allCoins = returnedValue
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text : String, coins : [CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter { coin  -> Bool in
            return coin.name.lowercased().contains(lowercasedText)
                || coin.symbol.lowercased().contains(lowercasedText)
                || coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    
    
}
