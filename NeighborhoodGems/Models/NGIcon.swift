//
//  NGIcon.swift
//  NeighborhoodGems
//
//

import Foundation

struct NGIcon: Codable {
    let prefix: String
    let suffix: String
    
    var url: String {
        return self.prefix + self.suffix
    }
}
