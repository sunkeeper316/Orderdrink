//
//  Order.swift
//  Orderdrink
//
//  Created by 黃德桑 on 2019/5/16.
//  Copyright © 2019 sun. All rights reserved.
//

import Foundation
struct OrderData: Codable {
    var data: [Order]
}

struct Order: Codable {
    var name: String
    var drink: String
    var sweet: String
    var ice: String
}

