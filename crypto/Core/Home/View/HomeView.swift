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
    @State private var showPortfolioView : Bool = false
    
    var body: some View {
        ZStack{
            Color.theme.background.ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortFolioView()
                        .presentationDetents([
                            .large
                        ])
                        .environmentObject(vm)
                })
            
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
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
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
            HStack {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReverse) ? 1.0 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReverse : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReverse) ? 1.0 : 0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReverse : .holdings
                    }
                }
            }
            
            HStack {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReverse) ? 1.0 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
                .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .price ? .priceReverse : .price
                    }
                }
            Button {
                withAnimation(.linear(duration: 2)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)

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
