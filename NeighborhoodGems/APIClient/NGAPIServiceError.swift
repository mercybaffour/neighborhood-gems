//
//  NGAPIServiceError.swift
//  NeighborhoodGems
//
//

import Foundation

enum NGAPIServiceError: Error {
    case failedToCreateRequest
    case failedToGetResults(message: String)
    
    var errorDescription: String {
        switch self {
        case .failedToCreateRequest:
            return "Error: Failed to create API request"
        case .failedToGetResults(let message):
            return "The server responded with message: \(message)"
        }
    }
}
