//
//  CoinImageRepository.swift
//  crypto
//
//  Created by ImDung on 16/7/24.
//

import Foundation
import SwiftUI
import Combine

class CoinImageRepository {
    
    @Published var image : UIImage? = nil
    var imageSubscription : AnyCancellable?
    private let coin : CoinModel
    private let localFileManager = LocalFileManager.instance
    private let imageName : String
    
    init(coin : CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let image = localFileManager.getImage(imageName: imageName) {
            print("get from local file manager")
            self.image = image
        }
        else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage(){
        print("Downloading image now")
        guard let url = URL(string: coin.image) else {return}
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion){ [weak self] returnedImage in
                guard 
                    let self = self,
                    let downloadImage = returnedImage
                else {return}
                self.image = downloadImage
                self.imageSubscription?.cancel()
                self.localFileManager.saveImage(image: downloadImage, imageName: imageName)
                
            }
    }
}
