//
//  NGTextFieldView.swift
//  NeighborhoodGems
//
//

import Foundation
import UIKit

extension UITextField {
    
    func loadDropdown(options: [String]) {
        self.inputView = NGPickerView(pickerOptions: options, pickerTextField: self)
    }
    
}
