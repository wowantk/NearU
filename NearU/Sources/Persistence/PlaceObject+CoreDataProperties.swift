//
//  PlaceObject+CoreDataProperties.swift
//  
//
//  Created by macbook on 02.05.2021.
//
//

import Foundation
import CoreData


extension PlaceObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceObject> {
        return NSFetchRequest<PlaceObject>(entityName: "PlaceObject")
    }

    @NSManaged public var adress: String?
    @NSManaged public var category: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lat: String?
    @NSManaged public var long: String?
    @NSManaged public var name: String?

}
