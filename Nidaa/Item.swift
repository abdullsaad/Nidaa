//
//  Item.swift
//  Nidaa
//
//  Created by Abdullah Alkhthlan on 2/14/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
