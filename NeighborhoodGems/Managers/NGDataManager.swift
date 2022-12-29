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
    
    lazy var placeDetail: NGPlace = {
        //Placeholder Data
        var icon = NGIcon(prefix: "fakePrefix", suffix: "fakeSuffix")
        var main = NGMain(latitude: 2.0, longitude: 3.0)
        var roof = NGRoof(latitude: 2.0, longitude: 3.0)
        var category = NGCategory(id: 123, name: "fakeName", icon: icon)
        var geocodes = NGGeocodes(main: main, roof: roof)
        var location = NGLocation(address: "fakeAddress", census_block: "fakeCB", country: "fakeCountry", cross_street: "fakeCT", dma: "fakeDMA", formatted_address: "fakeAddress", locality: "fakeLocality", neighborhood: ["fakeNeighborhood"], postcode: "fakePostcode", region: "fakeRegion")
        var place = NGPlace(fsq_id: "1234", categories: [category], distance: 1234, geocodes: geocodes, link: "www.google.com", location: location, name: "fakePlace", timezone: "fakeTimezone")
            
        return place
    } ()
}
