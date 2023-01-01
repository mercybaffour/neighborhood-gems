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
    
    lazy var placesList: [NGPlace] = {
        //Placeholder Data
        var list = [NGPlace]()
            
        return list
    } ()
    
    
    lazy var placeTips: [NGPlaceTip]? = {
        var list = [NGPlaceTip]()
            
        return list
        
    }()
}
