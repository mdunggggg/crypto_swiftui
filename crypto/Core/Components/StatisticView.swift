//
//  StatisticView.swift
//  crypto
//
//  Created by ImDung on 19/7/24.
//

import SwiftUI

struct StatisticView: View {
    
    let statistic : StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Text(statistic.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text(statistic.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption)
                    .rotationEffect(.degrees(statistic.isUp() ? 0 : 180))
                Text(statistic.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(statistic.isUp() ? Color.theme.green : Color.theme.red)
            .opacity(statistic.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        StatisticView(statistic: DeveloperPreview.dev.statistic)
        StatisticView(statistic: DeveloperPreview.dev.statistic2)
    }
}
