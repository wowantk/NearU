//
//  File.swift
//  testddd
//
//  Created by macbook on 21.04.2021.
//

import Foundation

struct Place:Codable {
    var id:UUID
    var name:String
    var category:String
    var adress:String
    var city: String
    var country: String
    var long:String
    var lat: String
}
