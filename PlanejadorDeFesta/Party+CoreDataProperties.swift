//
//  Party+CoreDataProperties.swift
//  PlanejadorDeFesta
//
//  Created by Lia Kassardjian on 14/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//
//

import Foundation
import CoreData


extension Party {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Party> {
        return NSFetchRequest<Party>(entityName: "Party")
    }

    @NSManaged public var doesDrink: Bool
    @NSManaged public var doesHaveMeal: Bool
    @NSManaged public var name: String?
    @NSManaged public var numOfDrunkGuests: Int16
    @NSManaged public var numOfGuests: Int16
    @NSManaged public var numOfHours: Int16
    @NSManaged public var id: Int32
    @NSManaged public var has: NSSet?

}

// MARK: Generated accessors for has
extension Party {

    @objc(addHasObject:)
    @NSManaged public func addToHas(_ value: Tasks)

    @objc(removeHasObject:)
    @NSManaged public func removeFromHas(_ value: Tasks)

    @objc(addHas:)
    @NSManaged public func addToHas(_ values: NSSet)

    @objc(removeHas:)
    @NSManaged public func removeFromHas(_ values: NSSet)

}
