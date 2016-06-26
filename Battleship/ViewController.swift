//
//  ViewController.swift
//  Battleship
//
//  Created by Sawyer Blatz on 6/25/16.
//  Copyright © 2016 Sawyer Blatz. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    
    
    @IBOutlet weak var xCoordinateInput: UITextField!
    @IBOutlet weak var yCoordinateInput: UITextField!
    
    let pickerData = ["-10", "-9", "-8", "-7", "-6", "-5", "-4", "-3", "-2", "-1", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpButtons()
        
    }
    
    func setUpButtons() {
        let picker: UIPickerView
        picker = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 300))
        picker.backgroundColor = .whiteColor()
        
        //picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.userInteractionEnabled = true
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        //toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        xCoordinateInput.inputAssistantItem.leadingBarButtonGroups = []
        xCoordinateInput.inputAssistantItem.trailingBarButtonGroups = []
        
        xCoordinateInput.inputView = picker
        xCoordinateInput.inputAccessoryView = toolBar
        
        yCoordinateInput.inputAssistantItem.leadingBarButtonGroups = []
        yCoordinateInput.inputAssistantItem.trailingBarButtonGroups = []
        yCoordinateInput.inputView = picker
        yCoordinateInput.inputAccessoryView = toolBar

    
    }
    
    func donePicker() {
        var textField = UITextField()
        var isAlive = false
        
        
        if xCoordinateInput.editing {
            textField = xCoordinateInput
            isAlive = true
        } else if yCoordinateInput.editing {
            textField = yCoordinateInput
            isAlive = true
        } else {
            isAlive = false
        }
        
        if (isAlive) {
            textField.resignFirstResponder()
            let pickView = textField.inputView as! UIPickerView
            textField.text = pickerData[pickView.selectedRowInComponent(0)]

        }
        
        
 }


    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

