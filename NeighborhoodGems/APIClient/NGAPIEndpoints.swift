//
//  NGAPIEndpoints.swift
//  NeighborhoodGems
//
//

import Foundation

enum APIs {
    
    //MARK: Namespace for Foursquare API
    enum Foursquare: RawRepresentable, NGAPIRequest {
        //ENDPOINTS
        case getPlaces
        case getPlaceTips(id: String)
        case getPlaceImage(id: String)

        //REQUEST URL, HTTP Methods, Headers, & Optional Data
        static let baseURL = URL(string: "https://api.foursquare.com/v3/places")!
        
        var apiKey: String {
            let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
            return apiKey!
        }

        var rawValue: String {
            switch self {
            case .getPlaces: return "/search"
            case .getPlaceTips(let id): return "/\(id)/tips"
            case .getPlaceImage(let id): return "/\(id)/photos"
            }
        }
        
        var httpMethod: String {
            switch self {
            case .getPlaces, .getPlaceTips, .getPlaceImage:
                return "GET"
            }
        }
        
        var headers: [String: Any]? {
            switch self {
            case .getPlaces, .getPlaceTips, .getPlaceImage:
                return ["Accept": "application/json",
                        "Authorization": apiKey
                ]
            }
        }
        
        var body: NSMutableData? {
            switch self {
            case .getPlaces, .getPlaceTips, .getPlaceImage:
                return nil
            }
        }
    }
    
    //MARK: Namespace for PredictHQ API
    enum PredictHQ: RawRepresentable, NGAPIRequest {
        //ENDPOINTS
        case getEvents
        
        //REQUEST URL, HTTP Methods, Headers, & Optional Data
        static let baseURL = URL(string: "https://api.predicthq.com/v1/" )!
        
        var apiToken: String {
            let apiToken = Bundle.main.infoDictionary?["API_TOKEN"] as? String
            return apiToken!
        }
        
        var rawValue: String {
            switch self {
            case .getEvents: return "events/"
            }
        }
        
        var httpMethod: String {
            switch self {
            case .getEvents:
                return "GET"
            }
        }
        
        var headers: [String: Any]? {
            switch self {
            case .getEvents:
                return ["Accept": "application/json",
                        "Authorization": "Bearer \(apiToken)"
                ]
            }
        }
        
        var body: NSMutableData? {
            switch self {
            case .getEvents:
                return nil
            }
        }
    }
    
    //MARK: Additional APIs
    
}

/// Extend the RawRepresentable Protocol to simplify url usage
extension RawRepresentable where RawValue == String, Self: NGAPIRequest {
    var url: URL {Self.baseURL.appendingPathComponent(rawValue)}
    
    init?(rawValue: String){ nil }
    
}


