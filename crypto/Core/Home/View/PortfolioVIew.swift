//
//  PortFolioView.swift
//  crypto
//
//  Created by ImDung on 20/7/24.
//

import SwiftUI

struct PortFolioView: View {
    @EnvironmentObject private var vm : HomeViewModel
    @State private var selectedCoin : CoinModel? = nil
    @State private var quantityText : String = ""
    @State private var showCheckmark : Bool = false
   
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit portfolio")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                   XMarkButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                  trailingNavbarButton
                }
            }
            .onChange(of: vm.searchText) { value in
                if value == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

extension PortFolioView {
    private var coinLogoList : some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10, content: {
                ForEach(vm.searchText.isEmpty ? vm.portfoliosCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1.0)
                        )
                    
                        
                }
            })
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
    
    private func updateSelectedCoin(coin : CoinModel) {
        selectedCoin = coin
        if let portfolioCoin = vm.portfoliosCoins.first(where: { coinModel in
            coinModel.id == coin.id
        }), let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            print("asdasd")
            quantityText = ""
        }
    }
    
    private var portfolioInputSection : some View {
        VStack {
            HStack{
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amount holding: ")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current value: ")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .padding()
        .font(.headline)
    }
    
    private var trailingNavbarButton : some View {
        HStack{
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0)

           
        }
        .font(.headline)
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin,
              let amount = Double(quantityText) else {return}
        
        vm.updatePortfolio(coin: coin, amount: amount)
        
        withAnimation(.easeIn){
            showCheckmark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            withAnimation(.easeOut){
                showCheckmark = false
            }
        })
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}

#Preview {
    PortFolioView()
        .environmentObject(DeveloperPreview.dev.homeViewModel)
}
