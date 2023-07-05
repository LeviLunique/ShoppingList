//
//  CoreDataProduct+CoreDataProperties.swift
//  AddProducts
//
//  Created by Levi Lunique on 14/05/23.
//
//

import Foundation
import CoreData


extension CoreDataProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataProduct> {
        return NSFetchRequest<CoreDataProduct>(entityName: "CoreDataProduct")
    }

    @NSManaged public var productId: UUID
    @NSManaged public var name: String?
    @NSManaged public var quantity: Int32
    @NSManaged public var totalValue: Float
    @NSManaged public var value: Float
    @NSManaged public var cart: CoreDataCart?

}

extension CoreDataProduct : Identifiable {

}
