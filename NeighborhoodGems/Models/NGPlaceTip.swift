//
//  NGPlaceTips.swift
//  NeighborhoodGems
//
//

import Foundation

struct NGPlaceTip: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, text
        //We're mapping the following JSON key to abide by Swift property naming conventions
        case createdAt = "created_at"
    }
    
    let id: String
    let createdAt: String
    let text: String
}
