//
//  NGEndpointCases.swift
//  NeighborhoodGems
//
//

import Foundation

enum EndpointCases: Endpoint {
    //CASES
    case getPlaces
    case getPlaceDetail
    
    //Endpoint Required Fields
    var apiKey: String {
        let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
        return apiKey!
    }
    
    var httpMethod: String {
        switch self {
        case .getPlaces, .getPlaceDetail:
            return "GET"
        }
    }
    
    var baseURLString: String {
        switch self {
        case .getPlaces, .getPlaceDetail:
            return "https://api.foursquare.com/"
        }
    }
    
    var path: String {
        switch self {
        case .getPlaces:
            return "v3/places/search"
        case .getPlaceDetail:
            return "v3/places/"
        }
    }
    
    var headers: [String: Any]? {
        switch self {
        case .getPlaces, .getPlaceDetail:
            return ["Accept": "application/json",
                    "Authorization": apiKey
            ]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getPlaces, .getPlaceDetail:
            return [:]
        }
    }
}
