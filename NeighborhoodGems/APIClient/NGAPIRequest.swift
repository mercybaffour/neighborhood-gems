//
//  NGAPIRequest.swift
//  NeighborhoodGems
//
//

import Foundation

///Creating a standardized HTTP request format that all endpoints should naturally abide by
protocol NGAPIRequest {
    
    static var baseURL: URL { get }
    var httpMethod: String { get }
    var headers: [String: Any]? { get }
    var body: NSMutableData? { get }
    
}


