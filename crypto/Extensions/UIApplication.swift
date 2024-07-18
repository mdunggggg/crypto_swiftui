//
//  UIApplication.swift
//  crypto
//
//  Created by ImDung on 18/7/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
