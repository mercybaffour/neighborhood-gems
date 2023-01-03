//
//  NGPickerView.swift
//  NeighborhoodGems
//
//

import Foundation
import UIKit

class NGPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {

    var pickerOptions : [String]!
    var pickerTextField : UITextField!
 
    init(pickerOptions: [String], pickerTextField: UITextField) {
        super.init(frame: CGRectZero)
 
        self.pickerOptions = pickerOptions
        self.pickerTextField = pickerTextField
 
        self.delegate = self
        self.dataSource = self
        
        DispatchQueue.main.async {
            if pickerOptions.count > 0 {
                self.pickerTextField.text = self.pickerOptions[0]
                self.pickerTextField.isEnabled = true
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.isEnabled = false
            }
        }
 
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
 
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerOptions[row]
    }
 
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerOptions[row]
    }

}
