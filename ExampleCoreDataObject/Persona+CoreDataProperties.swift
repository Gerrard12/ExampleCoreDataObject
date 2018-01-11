//
//  Persona+CoreDataProperties.swift
//  ExampleCoreDataObject
//
//  Created by gerardo on 11/01/18.
//  Copyright © 2018 Orbis. All rights reserved.
//
//

import Foundation
import CoreData


extension Persona {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Persona> {
        return NSFetchRequest<Persona>(entityName: "Persona")
    }

    @NSManaged public var nombre: String?

}
