//
//  Tasks+CoreDataProperties.swift
//  PlanejadorDeFesta
//
//  Created by Lia Kassardjian on 12/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var checkConclusion: Bool
    @NSManaged public var name: String?
    @NSManaged public var typeOfSection: Int16

}
