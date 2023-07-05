//
//  Product.swift
//  AddProducts
//
//  Created by Levi Lunique on 14/05/23.
//

import Foundation

struct Product: Identifiable, Hashable {
    var id: UUID
    var name: String
    var value: Float
    var quantity: Int32
    var totalValue: Float
}
