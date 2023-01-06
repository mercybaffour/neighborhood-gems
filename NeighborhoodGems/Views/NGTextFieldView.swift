//
//  NGTextFieldView.swift
//  NeighborhoodGems
//
//

import Foundation
import UIKit

extension UITextField {
    
    //Creating a picker - dropDown list for each search text field
    func loadDropdown(options: [String]) { //our options come from NGDataHelper: either categories or cities
        self.inputView = NGPickerView(pickerOptions: options, pickerTextField: self)
    }
    
    func setBaseStyling() {
        self.backgroundColor = UIColor.init(red: 213.0/255.0, green: 207.0/255.0, blue: 207.0/255.0, alpha: 1)
        self.layer.masksToBounds = false
        self.font = UIFont(name: "Futura", size: 18)
        self.textColor = .black
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.init(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shadowOpacity = 1.0
        self.layer.cornerRadius = 8.0
    }
}
