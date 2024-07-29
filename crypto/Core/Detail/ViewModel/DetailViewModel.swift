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
    
    @Published var overviewStatistics : [StatisticModel] = []
    @Published var additionalStatistic : [StatisticModel] = []
    @Published var coin : CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        coinDetailRepo = CoinDetailDataRepository(coinId: coin.id)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailRepo.$coinDetail
            .combineLatest($coin)
            .map(mapStat)
            .sink { [weak self] value in
                self?.additionalStatistic = value.additional
                self?.overviewStatistics = value.overview
            }
            .store(in: &cancellables)
    }
    
    private func mapStat(coinDetailModel : CoinDetailModel? , coinModel : CoinModel) -> (overview: [StatisticModel], additional : [StatisticModel]) {
        
        // overview
        let overviews = createOverviewArr(coinModel: coinModel)
        
        // additional
        let additions = createAdditionalArr(coinDetailModel: coinDetailModel, coinModel: coinModel)
        
        return (overviews, additions)
    }
    
    private func createOverviewArr(coinModel : CoinModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.asCurrencyWith2Decimals()
        let pricePerChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePerChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPerChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPerChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        return [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
    }
    
    private func createAdditionalArr(coinDetailModel : CoinDetailModel?, coinModel : CoinModel) -> [StatisticModel]{
        let high = coinModel.high24H?.asCurrencyWith2Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith2Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith2Decimals() ?? "n/a"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24H Price Change", value: priceChange, percentageChange: pricePercentChange2)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24H Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange2)
        
        let blocTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blocTimeStr = blocTime == 0 ? "n/a" : "\(blocTime)"
        let blocStat = StatisticModel(title: "Bloc Time", value: blocTimeStr)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hasing Algorithm", value: hashing)
        
        return [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blocStat, hashingStat
        ]
    }
}
