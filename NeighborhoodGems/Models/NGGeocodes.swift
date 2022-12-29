//
//  Geocodes.swift
//  NeighborhoodGems
//
//  Created by David Baffour on 12/28/22.
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
