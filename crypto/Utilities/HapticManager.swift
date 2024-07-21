//
//  HapticManager.swift
//  crypto
//
//  Created by ImDung on 21/7/24.
//

import Foundation
import SwiftUI
class HapticManager {
    static let generator = UINotificationFeedbackGenerator()
    
    static func notification(type : UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
