//
//  NGEvent.swift
//  NeighborhoodGems
//
//

import Foundation

struct NGEvent: Codable {
    var name: String?
    var id: String?
    var url: String?
    var dates: NGDates
}

struct NGDates: Codable {
    var start: NGStart
    var timezone: String?
}

struct NGStart: Codable {
    var localDate: String?
}
