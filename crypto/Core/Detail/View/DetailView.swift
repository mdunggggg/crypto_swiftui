//
//  DetailView.swift
//  crypto
//
//  Created by ImDung on 24/7/24.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var vm : DetailViewModel
    private let columns : [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
   
    private let spacing : CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Init \(coin.name)")
    }
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack{
                ChartView(coin: vm.coin)
                overviewTitle
                Divider()
                overviewGrid
                addtionalTitle
                Divider()
                additionalGrid
                
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                navItemBarTrailings
            }
        })
    }
}

extension DetailView {
    private var overviewTitle : some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var addtionalTitle : some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid : some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.overviewStatistics) {stat in
                    StatisticView(statistic: stat)
                }
        })
    }
    
    private var additionalGrid : some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.additionalStatistic) {stat in
                    StatisticView(statistic: stat)
                }
        })

    }
    
    private var navItemBarTrailings : some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
            .foregroundStyle(Color.theme.secondaryText)
            
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }

    }
}

#Preview {
    NavigationStack{
        DetailView(coin: DeveloperPreview.dev.coin)
    }
}
