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
    
    //Creating Places Endpoint request with specified parameters
    private static func createSearchRequest(term: String, city: String) -> URLRequest {
        let params = ["query": term, "near": city, "open_now": "true", "sort": "DISTANCE", "limit": "5"]
        let userEndpoint = EndpointCases.getPlaces
        return createRequest(endpoint: userEndpoint, params: params)
    }
    
    //Creating Places Endpoint request with specified parameters
    private static func createPlaceDetailRequest(id: String) -> URLRequest {
        let params = ["fsq_id": id]
        let userEndpoint = EndpointCases.getPlaceDetail
        return createRequest(endpoint: userEndpoint, params: params)
    }
    
    //Additional endpoint requests can be created here
    
    //Request method for getPlaces endpoint
    static func getPlacesList(term: String, city: String, completion: @escaping (Bool, [NGPlace]?) -> Void) {
        let request = createSearchRequest(term: term, city: city)
        
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
    
    //Request method for getPlaceDetail endpoint
    static func getPlaceDetail(id: String, completion: @escaping (Bool, NGPlace?) -> Void) {
        let request = createPlaceDetailRequest(id: id)
        
        //print(request)
        
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
            
            
            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode(NGPlace.self, from: data)
                //Means we have successfully received a response
                print(response)
                completion(true, response)
            } catch let jsonError {
              print(jsonError)
            }
            
            
        }
        task.resume()
    }
    
    //Requesting, then serving actual images
    static func getImage(imageUrl: URL, completion: @escaping (Bool, Data?) -> Void) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: imageUrl) { (data, response, error) in
            if let data = data, error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    completion(true, data)
            }
            else {
                completion(false, nil)
            }
        }
        task.resume()
    }
}
