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
    @Published var sortOption : SortOption = .holdings
    @Published var searchText = ""
    @Published var isLoading : Bool = false
    
    private let coinRepo = CoinDataRepository()
    private let marketRepo = MarketDataRepository()
    private let portfolioData = PortfolioDataRepository()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReverse, holdings, holdingsReverse, price, priceReverse
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $searchText
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true)
            .combineLatest(coinRepo.$allCoins, $sortOption)
            .map(filterAndSortCoins)
            .sink {[weak self] returnedValue in
                self?.allCoins = returnedValue
            }
            .store(in: &cancellables)
        
        
        $allCoins
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true)
            .combineLatest(portfolioData.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedValue in
                guard let self = self else {return}
                self.portfoliosCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedValue)
            }
            .store(in: &cancellables)
        
        marketRepo.$marketData
            .combineLatest($portfoliosCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedValue in
                self?.statistics = returnedValue
                self?.isLoading = false
            }.store(in: &cancellables)
     
      
    }
    
    func updatePortfolio(coin : CoinModel, amount : Double) {
        portfolioData.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinRepo.getCoins()
        marketRepo.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text : String, coins: [CoinModel], sort : SortOption) -> [CoinModel] {
        var filteredCoin = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &filteredCoin)
        return filteredCoin
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
    
    private func sortCoins(sort : SortOption, coins : inout [CoinModel]){
        switch sort {
        case .rank, .holdings:
            coins.sort { first, second in
                return first.rank < second.rank
            }
        case .rankReverse, .holdingsReverse:
            coins.sort { first, second in
                return first.rank > second.rank
            }
        case .price:
            coins.sort { first, second in
                return first.currentPrice > second.currentPrice
            }
        case .priceReverse:
            coins.sort { first, second in
                return first.currentPrice < second.currentPrice
            }
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins : [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReverse:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(coins : [CoinModel], portfolios : [PortfolioEntity]) -> [CoinModel] {
        coins.compactMap { currentCoin -> CoinModel? in
            guard let entity = portfolios.first(where: {$0.coinID == currentCoin.id}) else {return nil}
            return currentCoin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalMarketData(data : MarketDataModel?, portfolioCOins : [CoinModel]) -> [StatisticModel] {
        var stats : [StatisticModel] = []
        guard let data = data else {return stats}
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let bitcoinDominance = StatisticModel(title: "BC Dominance", value: data.btcDominance)
        let portfolioValue = portfolioCOins.map { coin -> Double in
            return coin.currentHoldingsValue
        }.reduce(0) { partialResult, num in
            return partialResult + num
        }
        
        let previosValue = portfolioCOins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
            let previosValue  = (currentValue) / (1 + percentChange)
            return previosValue
        }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previosValue) / previosValue) * 100
        
        let profolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        stats.append(contentsOf: [
            marketCap, volume, bitcoinDominance, profolio
        ])
        return stats
    }
    
    
    
}
