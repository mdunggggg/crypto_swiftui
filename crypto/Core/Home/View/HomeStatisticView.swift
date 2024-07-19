//
//  HomeStatisticView.swift
//  crypto
//
//  Created by ImDung on 19/7/24.
//

import SwiftUI

struct HomeStatisticView: View {
    @Binding var showPortfolio : Bool
    @EnvironmentObject private var vm : HomeViewModel
    
    var body: some View {
        HStack{
            ForEach(vm.statistics){ statistic in
                StatisticView(statistic: statistic)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

#Preview {
    HomeStatisticView(showPortfolio: .constant(false))
        .environmentObject(DeveloperPreview.dev.homeViewModel)
}
