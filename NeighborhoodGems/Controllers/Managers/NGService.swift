//
//  NGService.swift
//  NeighborhoodGems
//
// 
//

import Foundation

class NGService {
    
    //Generating URL object for the Foursquare Places API search endpoint
    static var searchURL = "https://api.foursquare.com/v3/places/search"
    
    //General base request method
    private static func createRequest(url: String, params: [String: String]) -> URLRequest {
        var components = URLComponents(string: url)!
        components.queryItems = params.map { (key, value) in URLQueryItem(name: key, value: value)}
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String {
            request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    //Specific search request method
    private static func createSearchRequest(term: String) -> URLRequest {
            let params = ["query": term, "ll": "47.606,-122.349358", "open_now": "true", "sort": "DISTANCE"]
            return createRequest(url: searchURL, params: params)
    }
    
    static func getPlacesList(term: String, completion: @escaping (Bool, [Place]?) -> Void) {
        let request = createSearchRequest(term: term)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,                              // data?
                let response = response as? HTTPURLResponse,  // HTTP response?
                200 ..< 300 ~= response.statusCode,           // status code range in 2xx -3xx?
                error == nil                                  // no error?
            else {
                completion(false, nil)
                return
            }
            
            //If conditions met --> Parse JSON object and access results field as array of objects
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            let results = responseObject!["results"] as? [AnyObject]
            
            //Collect all the data objects into a list
            var list = [Place]()
            for i in 0 ..< results!.count {
                //Checking if array object is a dictionary structure
                guard let place = results![i] as? [String: Any] else {
                    continue
                }
                
                //If condition met, access each array object and their field names --> create Place object and add to list
                if let id = place["fsq_id"] as? String,
                    let name = place["name"] as? String,
                    let distance = place["distance"] as? Int {
                    let placeDetail = Place(id: id, name: name, distance: distance)
                                       
                    list.append(placeDetail)
                    
                }
            }
            //Means we have successfully iterated through results array
            completion(true, list)
        }
        task.resume()
    }
    
}
