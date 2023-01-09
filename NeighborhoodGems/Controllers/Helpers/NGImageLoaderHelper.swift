//
//  NGImageLoaderHelper.swift
//  NeighborhoodGems
//
//

import Foundation

//This helper class will help us download images and handle in memory caching of downloaded images
class NGImageLoaderHelper {
    
    static let shared = NGImageLoaderHelper()
   
    // Initializing a dictionary-like object to help cache image data for a given url ID
    private var imageCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    //Making Network Call to "getPlacePhotos" endpoint: 1) Using place id to get the image url 2) With image url, make API call to receive final image data
    func getPlaceImage(id: String, completion: @escaping (Bool, Data?) -> Void) {
        //Checking initially to see if image has been cached using the place 'id' as key
        let key = id as NSString
        if let data = imageCache.object(forKey: key) {
            print("Loading from cache: \(key)")
            completion(true, data as Data)
            return
        }
        
        let userEndpoint = APIs.Foursquare.getPlaceImage(id: id)
        
        guard let request = NGAPIService.createFoursquareRequest(endpoint: userEndpoint, id: id) else {
            print(NGAPIServiceError.failedToCreateRequest.errorDescription)
            completion(false, nil)
            return
        }

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard
                let data = data,                                // data?
                let response = response as? HTTPURLResponse,    // HTTP response?
                200 ..< 300 ~= response.statusCode,             // status code in range 2xx?
                error == nil                                    // no error?
            else {
                if error != nil {
                    print(NGAPIServiceError.failedToGetResults(message: "Error accessing image from foursquare.com: /(error)").errorDescription)
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
                    
                    
                    //Caching into our dictionary-like object the data for this url
                    let value = data as? NSData
                    self?.imageCache.setObject(value!, forKey: key)
                    
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
}
