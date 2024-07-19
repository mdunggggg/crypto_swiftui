//
//  HomeView.swift
//  crypto
//
//  Created by ImDung on 16/7/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio : Bool = false
    @EnvironmentObject private var vm : HomeViewModel
    
    var body: some View {
        ZStack{
            Color.theme.background.ignoresSafeArea()
            
            VStack{
                homeHeader
                HomeStatisticView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                   
                columnTitles
                if !showPortfolio {
                    allCoinsList.transition(.move(edge: .leading))
                }
                if showPortfolio {
                    portfolioCoinsList.transition(.move(edge: .trailing))
                }
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

extension HomeView {
    private var homeHeader : some View {
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? -180 : 0))
                .onTapGesture {
                    withAnimation{
                        showPortfolio.toggle()
                    }
                }
        }
       
    }
    
    private var allCoinsList : some View {
        return List{
            ForEach(vm.allCoins){ coin in
                CoinRowView(coin: coin, showHoldingsColum: showPortfolio)
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinsList : some View {
        return List{
            ForEach(vm.portfoliosCoins){ coin in
                CoinRowView(coin: coin, showHoldingsColum: showPortfolio)
            }
        }
        .listStyle(.plain)
    }
    
    private var columnTitles : some View {
        return HStack{
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holding")
            }
            
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal, 24)
    }
}

#Preview {
    NavigationStack{
        HomeView()
            .toolbar(.hidden)
    }
    .environmentObject(DeveloperPreview.dev.homeViewModel)
}
