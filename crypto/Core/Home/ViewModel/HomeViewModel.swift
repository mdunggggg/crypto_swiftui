//
//  HomeViewModel.swift
//  crypto
//
//  Created by ImDung on 16/7/24.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    @Published var statistics : [StatisticModel] = []
    @Published var allCoins : [CoinModel] = []
    @Published var portfoliosCoins : [CoinModel] = []
    
    @Published var searchText = ""
    
    private let coinRepo = CoinDataRepository()
    private let marketRepo = MarketDataRepository()
    private let portfolioData = PortfolioDataRepository()
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
        
        marketRepo.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedValue in
                self?.statistics = returnedValue
            }.store(in: &cancellables)
        
        $allCoins
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true)
            .combineLatest(portfolioData.$savedEntities)
            .map { (coins, portfolios) -> [CoinModel] in
                coins.compactMap { currentCoin -> CoinModel? in
                    guard let entity = portfolios.first(where: {$0.coinID == currentCoin.id}) else {return nil}
                    return currentCoin.updateHoldings(amount: entity.amount)
                }
            }
            .sink { [weak self] returnedValue in
                self?.portfoliosCoins = returnedValue
            }
            .store(in: &cancellables)
      
    }
    
    func updatePortfolio(coin : CoinModel, amount : Double) {
        portfolioData.updatePortfolio(coin: coin, amount: amount)
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
    
    private func mapGlobalMarketData(data : MarketDataModel?) -> [StatisticModel] {
        var stats : [StatisticModel] = []
        guard let data = data else {return stats}
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let bitcoinDominance = StatisticModel(title: "BC Dominance", value: data.btcDominance)
        let profolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        stats.append(contentsOf: [
            marketCap, volume, bitcoinDominance, profolio
        ])
        return stats
    }
    
    
    
}
