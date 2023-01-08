//
//  NGEvents.swift
//  NeighborhoodGems
//

//

import Foundation

typealias TicketMaster = NGEvents

struct NGEvents: Codable {
    let _embedded: NGEventsEmbedded
}

struct NGEventsEmbedded: Codable {
    var events: [NGEvent]
}



