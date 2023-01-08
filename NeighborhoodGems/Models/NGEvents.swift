//
//  NGEvents.swift
//  NeighborhoodGems
//

//

import Foundation

struct NGEvents: Codable {
    
    enum CodingKeys: String, CodingKey {
        //We're mapping the following JSON key to abide by Swift property naming conventions
        case embedded = "_embedded"
    }
    
    let embedded: NGEventsEmbedded
}

struct NGEventsEmbedded: Codable {
    var events: [NGEvent]
}



