//
//  Place.swift
//  NeighborhoodGems
//
//

import Foundation

struct NGPlace: Codable {
    
    enum CodingKeys: String, CodingKey {
        case categories, distance, geocodes, link, location, name, timezone
        //We're mapping the JSON key "fsq_id" to "fsqID" to abide by Swift naming conventions
        case fsqId = "fsq_id"
    }
    
    let fsqId: String
    let categories: [NGCategory]
    let distance: Int?
    let geocodes: NGGeocodes
    let link: String
    let location: NGLocation
    let name: String
    let timezone: String?
    
}
