//
//  MarketDataRepository.swift
//  crypto
//
//  Created by ImDung on 19/7/24.
//

import Foundation
import Combine

class MarketDataRepository {
    @Published var marketData : MarketDataModel? = nil
    var marketDataSubscription : AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
        marketDataSubscription =
            NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { [weak self] returnGlobalData in
                self?.marketData = returnGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
