//
//  NGDataManager.swift
//  NeighborhoodGems
//
// 
//

import Foundation

class NGDataManager {
    
    static let shared = NGDataManager()
    
    private init() {
    }
    
    lazy var placesList: [Place] = {
        var list = [Place]()
        
        //Placeholder data
        for i in 0 ..< 10 {
            let place = Place(id: "486040195", name: "fakeName \(i)", distance: 10)
                list.append(place)
        }
            
        return list
    } ()
}
