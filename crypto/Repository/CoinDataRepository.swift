//
//  CoinDataRepository.swift
//  crypto
//
//  Created by ImDung on 16/7/24.
//

import Foundation
import Combine

class CoinDataRepository {
    @Published var allCoins : [CoinModel] = []
    var coinSubscription : AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(
            string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {return}
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300
                else {throw URLError(.badServerResponse)}
             
                return output.data
            }
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("\(error)")
                }
            } receiveValue: {[weak self] returnedData in
                self?.allCoins = returnedData
                self?.coinSubscription?.cancel()
            }
    }
}
