//
//  DetailView.swift
//  crypto
//
//  Created by ImDung on 24/7/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject var vm : DetailViewModel
    @State private var showFullDescription = false
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
                descriptionSection
                overviewGrid
                addtionalTitle
                Divider()
                additionalGrid
                websiteSection
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
    
    private var descriptionSection : some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription.removingHTMLOccurances)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    })
                    .accentColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    private var websiteSection : some View {
        VStack(alignment: .leading, spacing: 10){
            if let websiteURL = vm.websiteURL,
               let url = URL(string: websiteURL) {
                Link(destination: url, label: {
                    Text("Website")
                })
            }
            if let redditURL = vm.redditURL,
               let url = URL(string: redditURL) {
                Link(destination: url, label: {
                    Text("Reddit")
                })
            }
            
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}

#Preview {
    NavigationStack{
        DetailView(coin: DeveloperPreview.dev.coin)
    }
}
