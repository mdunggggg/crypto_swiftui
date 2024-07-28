//
//  CoinDetailDataService.swift
//  crypto
//
//  Created by ImDung on 28/7/24.
//

import Foundation
import Combine

class CoinDetailDataRepository {
    @Published var coinDetail : CoinDetailModel?
    var coinDetailSubscription : AnyCancellable?
    let id : String
    
    init(coinId id : String) {
        self.id = id
        getDetail()
    }
    
    func getDetail() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(id)/?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {return}
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedValue in
                self?.coinDetail = returnedValue
                self?.coinDetailSubscription?.cancel()
            }
    }
}
