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
    
    lazy var searchResultsList: [NGPlace] = {
        //Placeholder Data
        var list = [NGPlace]()
        return list
    } ()
    
    lazy var placeTips: [NGPlaceTip]? = {
        //Placeholder Data
        var list = [NGPlaceTip]()
        return list
        
    }()
    
    lazy var categories: [String] = {
        let categoryList = ["", "Arts and Entertainment", "Coffee", "Dining and Drinking", "Landmarks and Outdoors", "Retail", "Sports and Recreation"]
        return categoryList
    }()
    
    lazy var cities: [String] = {
        let cityList = ["", "New York", "Los Angeles", "Chicago", "Houston", "Washington", "Miami", "Philadelphia", "Atlanta", "Phoenix", "Boston", "San Francisco", "Riverside", "Detroit", "Seattle", "Minneapolis", "San Diego", "Tampa", "Denver", "St. Louis", "Baltimore", "Charlotte", "Orlando", "San Antonio", "Portland", "Sacramento", "Pittsburgh", "Las Vegas", "Austin"]
        return cityList
    }()
    
}
