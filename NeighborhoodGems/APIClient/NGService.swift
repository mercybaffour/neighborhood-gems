//
//  NGService.swift
//  NeighborhoodGems
//
// 
//

import Foundation

class NGService {
    
    //Creating general base request
    private static func createRequest(endpoint: Endpoint, params: [String: String]? = nil, id: String? = nil) -> URLRequest {
        //URL
        var components = URLComponents(string: endpoint.url)!
        
        if let parameters = params {
            components.queryItems = parameters.map { (key, value) in URLQueryItem(name: key, value: value)}
        }
        
        if let id = id {
            components.path += id
        }
        
        //Percent encoding
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
    private static func createSearchRequest(term: String, ll: String) -> URLRequest {
        let params = ["query": term, "ll": ll, "open_now": "true", "sort": "DISTANCE", "limit": "5"]
        let userEndpoint = EndpointCases.getPlaces
        return createRequest(endpoint: userEndpoint, params: params)
    }
    
    //Creating Place Detail Endpoint request with specified parameters
    private static func createPlaceDetailRequest(id: String) -> URLRequest {
        let userEndpoint = EndpointCases.getPlaceDetail
        return createRequest(endpoint: userEndpoint, id: id)
    }
    
    //Additional endpoint requests can be created here
    
    //Request method for getPlaces endpoint
    static func getPlacesList(term: String, ll: String, completion: @escaping (Bool, [NGPlace]?) -> Void) {
        let session = URLSession(configuration: .default)
        let request = createSearchRequest(term: term, ll: ll)
        
        let task = session.dataTask(with: request) { data, response, error in
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
        let session = URLSession(configuration: .default)
        let request = createPlaceDetailRequest(id: id)
        
        print(request)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,                              // data?
                let response = response as? HTTPURLResponse,  // HTTP response?
                200 ..< 300 ~= response.statusCode,           // status code range in 2xx?
                error == nil                                  // no error?
            else {
                print("stuck in data task")
                completion(false, nil)
                return
            }
            
            
            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode(NGPlace.self, from: data)
                //Means we have successfully received a response
                completion(true, response)
            } catch let jsonError {
                print(jsonError)
            }
            
            
        }
        task.resume()
    }
    
    //Requesting, then serving actual images
    static func getImage(imageUrl: String, completion: @escaping (Bool, Data?) -> Void) {
        //Headers
        let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
        let headers = ["Accept": "application/json", "Authorization": apiKey!]
        
        //Creating request
        let components = URLComponents(string: imageUrl)!
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession(configuration: .default)
        print("im in image call")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil,
               let response = response as? HTTPURLResponse, response.statusCode == 200,
               let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject], let responseObj = responseJSON[0] as? [String: Any] {
                    let prefix = responseObj["prefix"] as? String
                    let suffix = responseObj["suffix"] as? String
                    let combinedURL = "\(prefix!.dropLast())\(suffix!)"
                    print(combinedURL)
                    let url = URL(string: combinedURL)
                    let data = try? Data(contentsOf: url!)
                    
                    completion(true, data)
            }
            else {
                completion(false, nil)
            }
        }
        task.resume()
        
    }
}
