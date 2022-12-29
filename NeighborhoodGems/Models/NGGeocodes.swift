//
//  Geocodes.swift
//  NeighborhoodGems
//
//

import Foundation

struct NGGeocodes: Codable {
    let main: NGMain
    let roof: NGRoof
}

struct NGMain: Codable {
    let latitude: Double
    let longitude: Double
    
}

struct NGRoof: Codable {
    let latitude: Double
    let longitude: Double
    
}
