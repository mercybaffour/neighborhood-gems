//
//  Location.swift
//  NeighborhoodGems
//
//

import Foundation

struct NGLocation: Codable {
    
    enum CodingKeys: String, CodingKey {
        case address, country, dma, locality, neighborhood, postcode, region
        //We're mapping the following JSON keys to abide by Swift property name conventions
        case censusBlock = "census_block"
        case crossStreet = "cross_street"
        case formattedAddress = "formatted_address"
    }
    let address: String?
    let censusBlock: String?
    let country: String
    let crossStreet: String?
    let dma: String?
    let formattedAddress: String
    let locality: String
    let neighborhood: [String]?
    let postcode: String
    let region: String?
    
}
