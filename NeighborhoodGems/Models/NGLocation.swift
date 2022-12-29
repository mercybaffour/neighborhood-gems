//
//  Location.swift
//  NeighborhoodGems
//
//

import Foundation

struct NGLocation: Codable {
    let address: String
    let census_block: String
    let country: String
    let cross_street: String?
    let dma: String
    let formatted_address: String
    let locality: String
    let neighborhood: [String]
    let postcode: String
    let region: String
    
}
