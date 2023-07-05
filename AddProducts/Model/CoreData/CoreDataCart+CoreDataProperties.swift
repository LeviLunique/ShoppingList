//
//  CoreDataCart+CoreDataProperties.swift
//  AddProducts
//
//  Created by Levi Lunique on 14/05/23.
//
//

import Foundation
import CoreData


extension CoreDataCart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataCart> {
        return NSFetchRequest<CoreDataCart>(entityName: "CoreDataCart")
    }

    @NSManaged public var cartId: UUID
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension CoreDataCart {

    @objc(addToProductsObject:)
    @NSManaged public func addToProducts(_ value: CoreDataProduct)

    @objc(removeFromProductsObject:)
    @NSManaged public func removeFromProducts(_ value: CoreDataProduct)

    @objc(addToProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeFromProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}

extension CoreDataCart : Identifiable {

}
