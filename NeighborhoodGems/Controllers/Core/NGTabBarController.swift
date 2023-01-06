//
//  ViewController.swift
//  NeighborhoodGems
//
//  
//

import UIKit

class NGTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTabs()
        
    }
    
    ///For each feature, 1) Places and 2) Events, embed their navigation controllers in the main tab controller
    private func setUpTabs() {
        //Create instances of root view controllers to be attached to a navigation controller later
        let placeListVC = NGPlaceListViewController()
        let eventsVC = NGEventsViewController()

        //Setting up 'Places' navigation stack interface
        let nav1 = UINavigationController(rootViewController: placeListVC)
        
        //Setting up 'Events' navigation stack interface
        let nav2 = UINavigationController(rootViewController: eventsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Events", image: UIImage(systemName: "ticket"), tag: 2)
        
        
        //Attach navigation interfaces to tab bar controller
        setViewControllers([nav1, nav2], animated: true)
        
    }

}

