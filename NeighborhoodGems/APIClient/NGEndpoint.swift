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
    var body: [String: Any]? { get }
}

extension NGEndpoint {
    var url: String {
        return baseURLString + path
    }
}
