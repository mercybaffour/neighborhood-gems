//
//  NGService.swift
//  NeighborhoodGems
//
//

import Foundation

class NGAPIService {
    
    //MARK: Foursquare API Requests
    
    ///Creating a  base network request
    private static func createFoursquareRequest(endpoint: APIs.Foursquare, params: [String: String]? = nil, id: String? = nil) -> URLRequest {
        
        // Get base url
        var url: URL {
            switch endpoint {
                case .getPlaces:
                    let url = APIs.Foursquare.getPlaces.url
                    return url
                case .getPlaceTips:
                    let url = APIs.Foursquare.getPlaceTips(id: id!).url
                    return url
                case .getPlaceImage:
                    let url = APIs.Foursquare.getPlaceImage(id: id!).url
                    return url
            }
        }
       
        // Using the URLComponents class to parse and construct our full URL
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        if let parameters = params {
            components.queryItems = parameters.map { (key, value) in URLQueryItem(name: key, value: value)}
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        //Building our Request
        var request = URLRequest(url: components.url!)
        
        request.httpMethod = endpoint.httpMethod
        
        endpoint.headers?.forEach({ header in
            request.setValue(header.value as? String, forHTTPHeaderField: header.key)
        })
        
        return request
    }
    
    /// Making network call to  getPlaces endpoint based on user's current location
    static func getPlacesList(term: String, ll: String, completion: @escaping (Bool, [NGPlace]?) -> Void) {
        
        let params = ["query": term, "ll": ll, "sort": "RELEVANCE", "limit": "50"]
        let userEndpoint = APIs.Foursquare.getPlaces
       
        let request = createFoursquareRequest(endpoint: userEndpoint, params: params)
        
        //Using URLSession class to manage HTTP session for this request
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,                                // data?
                let response = response as? HTTPURLResponse,    // HTTP response?
                200 ..< 300 ~= response.statusCode,             // status code in range 2xx?
                error == nil                                    // no error?
            else {
                if error != nil {
                    print("Error accessing foursquare.com: /(error)")
                }
                completion(false, nil)
                return
            }
            
            //Initializing a list to store our API results
            var list = [NGPlace]()
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedResponse = try jsonDecoder.decode(NGPlaces.self, from: data)
                list = decodedResponse.results
            } catch let jsonError {
                print(jsonError)
            }
            
            //Means we have successfully collected all data objects into a list and this list will be assigned to our placesList in NGDataHelper
            completion(true, list)
        }
        task.resume()
    }
    
    /// Making network call to "getPlaces" endpoint based on user search
    static func getUserPlacesList(term: String, city: String, completion: @escaping (Bool, [NGPlace]?) -> Void) {
        
        let params = ["query": term, "near": city, "sort": "RELEVANCE", "limit": "50"]
        let userEndpoint = APIs.Foursquare.getPlaces
        let request = createFoursquareRequest(endpoint: userEndpoint, params: params)
        
        //Using URLSession class to manage HTTP session for this request
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,                                // data?
                let response = response as? HTTPURLResponse,    // HTTP response?
                200 ..< 300 ~= response.statusCode,             // status code in range 2xx?
                error == nil                                    // no error?
            else {
                 if error != nil {
                    print("Error accessing foursquare.com: /(error)")
                }
                completion(false, nil)
                return
            }
            
            //Initializing an empty list to store our API results
            var list = [NGPlace]()
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedResponse = try jsonDecoder.decode(NGPlaces.self, from: data)
                list = decodedResponse.results
            } catch let jsonError {
                print(jsonError)
            }
            
            //Means we have successfully collected all data objects into a list and this list will be assigned to our searchResultsList in NGDataHelper
            completion(true, list)
        }
        task.resume()
    }

    
    /// Making network call to  "getPlaceTips" endpoint
    static func getPlaceTips(id: String, completion: @escaping (Bool, [NGPlaceTip]?) -> Void) {
        
        let userEndpoint = APIs.Foursquare.getPlaceTips(id: id)
        let request = createFoursquareRequest(endpoint: userEndpoint, id: id)
        
        //Using URLSession class to manage HTTP session for this request
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,                                // data?
                let response = response as? HTTPURLResponse,    // HTTP response?
                200 ..< 300 ~= response.statusCode,             // status code in range 2xx?
                error == nil                                    // no error?
            else {
                if error != nil {
                    print("Error accessing foursquare.com: /(error)")
                }
                completion(false, nil)
                return
            }
            
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedResponse = try jsonDecoder.decode([NGPlaceTip].self, from: data)
                //Means we have successfully collected a data object for the relevant place
                completion(true, decodedResponse)
            } catch let jsonError {
                print(jsonError)
            }
            
          
        }
        task.resume()
    }
    
    ///Making Network Call to "getPlacePhotos" endpoint
    static func getPlaceImage(id: String, completion: @escaping (Bool, Data?) -> Void) {
        let userEndpoint = APIs.Foursquare.getPlaceImage(id: id)
        let request = createFoursquareRequest(endpoint: userEndpoint, id: id)

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,                                // data?
                let response = response as? HTTPURLResponse,    // HTTP response?
                200 ..< 300 ~= response.statusCode,             // status code in range 2xx?
                error == nil                                    // no error?
            else {
                if error != nil {
                    print("Error accessing image from foursquare.com: /(error)")
                }
                completion(false, nil)
                return
            }
            
            
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject]
                if responseJSON!.isEmpty {
                    completion(false, nil)
                    return
                }
                
                if let responseObj = responseJSON![0] as? [String: Any] {
                    //Assembling photo URL
                    let prefix = responseObj["prefix"] as? String
                    let suffix = responseObj["suffix"] as? String
                    let combinedURL = "\(prefix!)300x300\(suffix!)"
                    
                    //Constructing a data object with the data from the location specified by the photo URL.
                    let url = URL(string: combinedURL)
                    let data = try? Data(contentsOf: url!)
                    
                    //Means we have succesfully constructed a data object and this object will be used to set the images in our collectionViews of our view controllers
                    completion(true, data)
                } else {
                    completion(false, nil)
                }
            } catch let jsonError {
                print(jsonError)
            }
          
        }
        task.resume()
    }
     
    // MARK: Ticketmaster API Requests
    
    ///Creating a  base network request
    private static func createTicketmasterRequest(endpoint: APIs.Ticketmaster, params: [String: String]? = nil, id: String? = nil) -> URLRequest {
        
        // Get base url
        var url: URL {
            switch endpoint {
                case .getEvents:
                    let url = APIs.Ticketmaster.getEvents.url
                    return url
            }
        }
       
        // Using the URLComponents class to parse and construct our full URL
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        if let parameters = params {
            components.queryItems = parameters.map { (key, value) in URLQueryItem(name: key, value: value)}
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        //Building our Request
        var request = URLRequest(url: components.url!)
        
        request.httpMethod = endpoint.httpMethod
        
        endpoint.headers?.forEach({ header in
            request.setValue(header.value as? String, forHTTPHeaderField: header.key)
        })
        
        return request
    }
    
    /// Making network call to "getEvents" endpoint
    static func getEvents(ll: String, completion: @escaping (Bool, [NGEvent]?) -> Void) {
        let apiKey = Bundle.main.infoDictionary?["TM_API_KEY"] as? String
            
        let params = ["apikey": apiKey!, "latlong": ll]
        let userEndpoint = APIs.Ticketmaster.getEvents
        let request = createTicketmasterRequest(endpoint: userEndpoint, params: params)
        
        //Using URLSession class to manage HTTP session for this request
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,                                // data?
                let response = response as? HTTPURLResponse,    // HTTP response?
                200 ..< 300 ~= response.statusCode,             // status code in range 2xx?
                error == nil                                    // no error?
            else {
                 if error != nil {
                    print("Error accessing ticketmaster.com: /(error)")
                }
                completion(false, nil)
                return
            }
            
            var list = [NGEvent]()
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedResponse = try jsonDecoder.decode(NGEvents.self, from: data)
                
                //Storing decoded response in our list and sorting by date chronologically
                list = decodedResponse.embedded.events.sorted(by: { $0.dates.start.localDate.compare($1.dates.start.localDate) == .orderedAscending })
    
            } catch let jsonError {
                print(jsonError)
            }
            //Means we have successfully collected all data objects into a list and will assign it to eventsList in NGDataHelper
            completion(true, list)
        }
        task.resume()
    }
}
