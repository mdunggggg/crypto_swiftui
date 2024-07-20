//
//  XMarkButton.swift
//  crypto
//
//  Created by ImDung on 20/7/24.
//

import SwiftUI

struct XMarkButton: View {
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    XMarkButton()
}
