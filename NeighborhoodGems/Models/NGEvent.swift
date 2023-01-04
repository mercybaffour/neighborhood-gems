//
//  NGEvent.swift
//  NeighborhoodGems
//
//

import Foundation

struct NGEvent: Codable {
    var id: String?
    var title: String?
    var description: String?
    var category: String?
    var start: String?
    var end: String?
    var predicted_end: String?
    var updated: String?
    var first_seen: String?
    var timezone: String?
    var duration: Double?
    var rank: Int?
    var local_rank: Int?
    var aviation_rank: Int?
    var country: String?
    var location: [Double]?
}
