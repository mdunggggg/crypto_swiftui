//
//  String.swift
//  crypto
//
//  Created by ImDung on 29/7/24.
//

import Foundation

extension String {
    var removingHTMLOccurances : String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
