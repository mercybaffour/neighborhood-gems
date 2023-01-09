//
//  NGDataManager.swift
//  NeighborhoodGems
//
// 
//

import Foundation

//This helper class will help store our data coming from APIs and will also store the options needed for our dropdown picker list
class NGDataHelper {
    
    static let shared = NGDataHelper()
    
    private init() {}
    
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
    
    lazy var eventsList: [NGEvent] = {
        //Placeholder Data
        var list = [NGEvent]()
        return list
    } ()
    
    //Category options for the dropdown of categorySearchField
    lazy var categories: [String] = {
        let categoryList = ["", "Arts and Entertainment", "Coffee", "Dining and Drinking", "Landmarks and Outdoors", "Retail", "Sports and Recreation"]
        return categoryList
    }()
    
    //City options for the dropdown of citySearchField
    lazy var cities: [String] = {
        let cityList = ["", "New York", "Los Angeles", "Chicago", "Houston", "Washington", "Miami", "Philadelphia", "Atlanta", "Phoenix", "Boston", "San Francisco", "Riverside", "Detroit", "Seattle", "Minneapolis", "San Diego", "Tampa", "Denver", "St. Louis", "Baltimore", "Charlotte", "Orlando", "San Antonio", "Portland", "Sacramento", "Pittsburgh", "Las Vegas", "Austin"]
        return cityList
    }()
    
}
