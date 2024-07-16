//
//  CoinRowView.swift
//  crypto
//
//  Created by ImDung on 16/7/24.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin : CoinModel
    let showHoldingsColum : Bool
    
    var body: some View {
        HStack(spacing: 0, content: {
            
            leftColumn
            Spacer()
            if showHoldingsColum {
                centerColumn
            }
            rightColumn
            
        })
        .font(.subheadline)
    }
}

extension CoinRowView {
    private var leftColumn : some View {
        return HStack(spacing: 0){
            Text(String(coin.rank))
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            Circle()
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundStyle(Color.theme.accent)
        }
    }
    private var centerColumn : some View {
        return VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    private var rightColumn : some View {
         return VStack(alignment: .trailing){
             Text("\(coin.currentPrice.asCurrencyWith6Decimals())")
                 .bold()
                 .foregroundStyle(Color.theme.accent)
             Text("\((coin.priceChangePercentage24H ?? 0).asPercentString())")
                 .foregroundStyle((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
         }
         .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CoinRowView(coin: DeveloperPreview.dev.coin, showHoldingsColum: true)
}
