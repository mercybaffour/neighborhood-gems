//
//  NGAPIRequest.swift
//  NeighborhoodGems
//
//

import Foundation

protocol NGAPIRequest {
    
    static var baseURL: URL { get }
    var httpMethod: String { get }
    var headers: [String: Any]? { get }
    var body: NSMutableData? { get }
    
}


