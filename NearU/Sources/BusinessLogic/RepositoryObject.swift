//
//  RepositoryObject.swift
//  TestUrlSession
//
//  Created by Volodymyr on 4/19/21.
//

import Foundation

// MARK: - Location
struct Location: Codable {
    let response: Response
    
    // MARK: - Response
    struct Response: Codable {
        let venues: [Venue]
    }
    
    // MARK: - Venue
    struct Venue: Codable {
        let  name: String
        let location: LocationClass
        let categories: [Category]
        enum CodingKeys: String, CodingKey {
            case  name, location, categories
        }
    }
    
    // MARK: - Category
    struct Category: Codable {
        let  name: String
    }
    
    // MARK: - LocationClass
    struct LocationClass: Codable {
        let lat, lng: Double
        let formattedAddress: [String]
    }
    
}
