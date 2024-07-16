//
//  CoinImageViewModel.swift
//  crypto
//
//  Created by ImDung on 16/7/24.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel : ObservableObject {
    @Published var image : UIImage? = nil
    @Published var isLoading : Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private let coinImageRepo : CoinImageRepository
    private let coin : CoinModel
    init(coin : CoinModel) {
        self.coin = coin
        coinImageRepo = CoinImageRepository(coin: coin)
        getImage()
    }
    
    private func getImage(){
        coinImageRepo.$image
            .sink { [weak self] completion in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)

    }
}
