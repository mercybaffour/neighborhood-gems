//
//  NGEndpointCases.swift
//  NeighborhoodGems
//
//

import Foundation

enum NGEndpointCases: NGEndpoint {
    //CASES
    case getPlaces
    case getPlaceTips
    case getEvents
    
    //Endpoint Required Fields
    var apiKey: String {
        let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
        return apiKey!
    }
    
    var apiToken: String {
        let apiToken = Bundle.main.infoDictionary?["API_TOKEN"] as? String
        return apiToken!
    }
    
    var httpMethod: String {
        switch self {
        case .getPlaces, .getPlaceTips, .getEvents:
            return "GET"
        }
    }
    
    var baseURLString: String {
        switch self {
        case .getPlaces, .getPlaceTips:
            return "https://api.foursquare.com/"
        case .getEvents:
            return "https://api.predicthq.com/v1/"
        }
    }
    
    var path: String {
        switch self {
        case .getPlaces:
            return "v3/places/search"
        case .getPlaceTips:
            return "v3/places/"
        case .getEvents:
            return "events/"
        }
    }
    
    var headers: [String: Any]? {
        switch self {
        case .getPlaces, .getPlaceTips:
            return ["Accept": "application/json",
                    "Authorization": apiKey
            ]
        case .getEvents:
            return ["Accept": "application/json",
                    "Authorization": "Bearer \(apiToken)"
            ]
        }
    }
    
    var body: NSMutableData? {
        switch self {
        case .getPlaces, .getPlaceTips, .getEvents:
            return nil
        }
    }
}
