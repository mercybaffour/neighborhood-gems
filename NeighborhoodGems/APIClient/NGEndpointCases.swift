//
//  NGEndpointCases.swift
//  NeighborhoodGems
//
//

import Foundation

enum EndpointCases: Endpoint {
    //CASES
    case getPlaces
    
    //Endpoint Required Fields
    var apiKey: String {
        let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
        return apiKey!
    }
    
    var httpMethod: String {
        switch self {
        case .getPlaces:
            return "GET"
        }
    }
    
    var baseURLString: String {
        switch self {
        case .getPlaces:
            return "https://api.foursquare.com/"
        }
    }
    
    var path: String {
        switch self {
        case .getPlaces:
            return "v3/places/search"
        }
    }
    
    var headers: [String: Any]? {
        switch self {
        case .getPlaces:
            return ["Accept": "application/json",
                    "Authorization": apiKey
            ]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getPlaces:
            return [:]
        }
    }
}
