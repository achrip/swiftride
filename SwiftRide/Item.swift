//
//  Item.swift
//  SwiftRide
//
//  Created by Ashraf Alif Adillah on 17/03/25.
//

import Foundation
import SwiftData

@Model
 class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
