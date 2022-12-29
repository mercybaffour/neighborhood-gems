//
//  NGService.swift
//  NeighborhoodGems
//
// 
//

import Foundation

class NGService {
    
    //Creating general base request
    private static func createRequest(endpoint: Endpoint, params: [String: String]) -> URLRequest {
        //URL
        var components = URLComponents(string: endpoint.url)!
        components.queryItems = params.map { (key, value) in URLQueryItem(name: key, value: value)}
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url!)
        
        //HTTP Method
        request.httpMethod = endpoint.httpMethod
        
        //HTTP Headers
        endpoint.headers?.forEach({ header in
                request.setValue(header.value as? String, forHTTPHeaderField: header.key)
        })
        
        return request
    }
    
    //Creating Places endpoint request with specified parameters
    private static func createSearchRequest(term: String) -> URLRequest {
        let params = ["query": term, "ll": "47.606,-122.349358", "open_now": "true", "sort": "DISTANCE"]
        let userEndpoint = EndpointCases.getPlaces
        return createRequest(endpoint: userEndpoint, params: params)
    }
    
    //Additional endpoint requests can be created here
    
    //Request method for getPlaces endpoint
    static func getPlacesList(term: String, completion: @escaping (Bool, [NGPlace]?) -> Void) {
        let request = createSearchRequest(term: term)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,                              // data?
                let response = response as? HTTPURLResponse,  // HTTP response?
                200 ..< 300 ~= response.statusCode,           // status code range in 2xx?
                error == nil                                  // no error?
            else {
                completion(false, nil)
                return
            }
            
            var list = [NGPlace]()
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedResponse = try jsonDecoder.decode(NGPlaces.self, from: data)
                list = decodedResponse.results
            } catch let jsonError {
              print(jsonError)
            }
            
            //Means we have successfully collected all data objects into a list
            completion(true, list)
        }
        task.resume()
    }
    
}
