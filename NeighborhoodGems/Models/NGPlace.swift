//
//  Place.swift
//  NeighborhoodGems
//
//

import Foundation

struct NGPlace: Codable {
    let fsq_id: String
    let categories: [NGCategory]
    let distance: Int?
    let geocodes: NGGeocodes
    let link: String
    let location: NGLocation
    let name: String
    let timezone: String?
    
}
