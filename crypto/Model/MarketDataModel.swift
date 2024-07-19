//
//  MarketDataModel.swift
//  crypto
//
//  Created by ImDung on 19/7/24.
//

import Foundation

/*
    https://api.coingecko.com/api/v3/global
 {
   "data": {
     "active_cryptocurrencies": 14918,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 1158,
     "total_market_cap": {
       "btc": 38328739.686231375,
       "eth": 726730970.924881,
     },
     "total_volume": {
       "btc": 1363764.247430402,
       "eth": 25857612.949474555,
       "sats": 136376424743040.2
     },
     "market_cap_percentage": {
       "btc": 51.46992873101617,
       "eth": 16.543148502445202,
       "usdt": 4.5346983891766754,
     },
     "market_cap_change_percentage_24h_usd": 2.1686108123241756,
     "updated_at": 1721403974
   }
 }
 
 */

struct GlobalData: Codable {
    let data: MarketDataModel
}

struct MarketDataModel: Codable {
    let activeCryptocurrencies, upcomingIcos, ongoingIcos, endedIcos: Int
    let markets: Int
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    let updatedAt: Int

    enum CodingKeys: String, CodingKey {
        case activeCryptocurrencies = "active_cryptocurrencies"
        case upcomingIcos = "upcoming_icos"
        case ongoingIcos = "ongoing_icos"
        case endedIcos = "ended_icos"
        case markets
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
        case updatedAt = "updated_at"
    }
    
    var marketCap : String {
        if let item = totalMarketCap.first(where: { (key, value) -> Bool in
            return key == "usd"
        }){
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume : String {
        if let item = totalVolume.first(where: { (key, value) -> Bool in
            return key == "usd"
        }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance : String {
        if let item = marketCapPercentage.first(where: { (key, value) -> Bool in
            return key == "btc"
        }) {
            return item.value.asPercentString()
        }
        return ""
    }
}
