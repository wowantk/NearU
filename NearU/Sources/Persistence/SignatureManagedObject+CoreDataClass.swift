//
//  SignatureManagedObject+CoreDataClass.swift
//  
//
//  Created by macbook on 02.05.2021.
//
//

import Foundation
import CoreData

@objc(SignatureManagedObject)
public class SignatureManagedObject: NSManagedObject {
    func sign() {
        let now = NSDate()
        
        if date_created == .none {
            date_created = now
        }
        
        date_modified = now 
    }
}
