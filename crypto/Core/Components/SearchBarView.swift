//
//  SearchBarView.swift
//  crypto
//
//  Created by ImDung on 18/7/24.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText : String
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundStyle(searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent)
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundStyle(Color.theme.accent)
                .autocorrectionDisabled(false)
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                }
        }
        .font(.headline)
        .padding()
        .background()
        .cornerRadius(25)
        .shadow(color: .theme.accent.opacity(0.25), radius: 10, x: 0, y: 0)
        .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        SearchBarView(searchText: .constant("")).preferredColorScheme(.light)
        SearchBarView(searchText: .constant("")).preferredColorScheme(.dark)
    }
}
