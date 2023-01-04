//
//  NGEndpoint.swift
//  NeighborhoodGems
//
//

import Foundation

protocol NGEndpoint {
    var httpMethod: String { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: Any]? { get }
    var body: NSMutableData? { get }
}

extension NGEndpoint {
    var url: String {
        return baseURLString + path
    }
}
