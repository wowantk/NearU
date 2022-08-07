//
//  SignatureManagedObject+CoreDataProperties.swift
//  
//
//  Created by macbook on 02.05.2021.
//
//

import Foundation
import CoreData


extension SignatureManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SignatureManagedObject> {
        return NSFetchRequest<SignatureManagedObject>(entityName: "SignatureManagedObject")
    }

    @NSManaged public var date_created: NSDate?
    @NSManaged public var date_modified: NSDate?

}
