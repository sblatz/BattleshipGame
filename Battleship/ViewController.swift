//
//  ViewController.swift
//  Battleship
//
//  Created by Sawyer Blatz on 6/25/16.
//  Copyright © 2016 Sawyer Blatz. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    private var engine = BattleshipEngine()
    
    
    let shipCell = UIImage(named: "ShipCell.png")
    let waterCell = UIImage(named: "WaterCell.png")
    let waterCellAxis = UIImage(named: "WaterCellAxis2.png")
    
    
    //create an array of buttons so we can keep track of which ones have been colored grey
    var buttonArray = [UIButton]()
    
    @IBOutlet weak var xCoordinateInput: UITextField!
    @IBOutlet weak var yCoordinateInput: UITextField!
    @IBOutlet weak var commaLabel: UILabel!
    @IBOutlet weak var leftParenthLabel: UILabel!
    @IBOutlet weak var rightParenthLabel: UILabel!
    @IBOutlet weak var aimLabel: UILabel!
    
    @IBOutlet weak var imageOfShip: UIButton!
    
    @IBOutlet weak var shipDescription: UILabel!
    
    @IBAction func rotateButton(sender: UIButton) {
        
        //will the rotation go out of bounds?
        
        var currentRotation = engine.currentShipBeingPlaced.rotation
        var currentButtonTag = buttonArray[1].tag
        let digit = buttonArray[0].currentTitle!
        let xCoordinate = Int(digit.substringToIndex(digit.startIndex.advancedBy(1)))!
        let yCoordinate = Int(digit.substringFromIndex(digit.endIndex.advancedBy(-1)))!
        
        removeShipFromView()
        buttonArray.removeAll()
        switch (currentRotation) {
        case 0:
            
            
            
            //if this is legal...
            
            if (11*engine.currentShipBeingPlaced.width + currentButtonTag < 121) {
                //in bounds... now does it hit another ship?
                
                engine.currentShipBeingPlaced.rotation = 1
                
                if let theButton = self.view.viewWithTag(currentButtonTag) as? UIButton {
                    buttonArray.append(theButton)
                    theButton.setImage(shipCell, forState: .Normal)
                }
                
                for i in 1...engine.currentShipBeingPlaced.width-1 {
                    currentButtonTag += 11
                    if let button = self.view.viewWithTag(currentButtonTag) as? UIButton
                    {
                        if (engine.player1Board[yCoordinate][xCoordinate] == "W") {
                            buttonArray.append(button)
                            button.setImage(shipCell, forState: .Normal)
                        }
                        
                    }
                    
                    
                }
                
            }
        default:
            print("Nope")
        }
        
        
    }
    
    
    func removeShipFromView() {
        
        //this will clear out all the previous ship cells
        for buttons in buttonArray {
            if (buttons.tag == 6 || buttons.tag == 17 || buttons.tag == 28 || buttons.tag == 39 || buttons.tag == 50 || buttons.tag == 61 || buttons.tag == 72 || buttons.tag == 83 || buttons.tag == 94 || buttons.tag == 105 || buttons.tag == 116 || ((buttons.tag < 67) && (buttons.tag > 54)) ) {
                
                buttons.setImage(waterCellAxis, forState: .Normal)
                
            } else {
                buttons.setImage(waterCell, forState: .Normal)
                
            }
            
            buttonArray.removeFirst()
        }
        
    }
    
    var currElementInArray = 0
    
    //TODO: On final ship placement, transition to gameplay
    @IBAction func confirmButton(sender: UIButton) {
        
        
        
        currElementInArray += 1
        
        if (buttonArray.count > 0) {
            
            let digit = buttonArray[0].currentTitle!
            
            
            let xCoordinate = Int(digit.substringToIndex(digit.startIndex.advancedBy(1)))!
            
            let yCoordinate = Int(digit.substringFromIndex(digit.endIndex.advancedBy(-1)))!
            
            
            engine.placeShip(xCoordinate, yLocation: yCoordinate, ship: engine.currentShipBeingPlaced)
            
            
            engine.printPlayer1Board()
            
            //wipe buttonArray on confirm.
            buttonArray.removeAll()
            
            
            
            let textArray = ["Destroyer - 2 spaces", "Submarine - 3 spaces", "Cruiser - 3 spaces", "Battleship - 4 spaces", "Carrier - 5 spaces"]
            
            
            let shipPicture = UIImage(named: engine.currentShipBeingPlaced.name + ".png")
            shipDescription.text = textArray[currElementInArray]
            
            imageOfShip.setImage(shipPicture, forState: .Normal)
            
        }
        
        //change the image of the ship and the description text
        
    }
    
    
    //TODO: Rotate Button!
    
    
    
    @IBAction func cellButton(sender: UIButton) {
        //our coordinates are told to us as 0,0 (top left) up to 10,10 (bottom right)
        let digit = sender.currentTitle!
        var xCoordinate = 0
        var yCoordinate = 0
        //print(digit)
        
        //is the cellButton in the last row? If so we need to grab the whole "y" coordinate (e.g "10" not just one digit)
        
        if (sender.tag > 110) {
            // in the last row so the yCoordinate is just 10.
            xCoordinate = Int(digit.substringToIndex(digit.startIndex.advancedBy(1)))!
            yCoordinate = 10
            
        } else {
            
            xCoordinate = Int(digit.substringToIndex(digit.startIndex.advancedBy(1)))!
            yCoordinate = Int(digit.substringFromIndex(digit.endIndex.advancedBy(-1)))!
            
        }
        
        
        
        //print(xCoordinate)
        //print(yCoordinate)
        
        var currentButtonTag = sender.tag
        
        var isValidPlacement = true
        
        
        //place the current ship where we touched at visually (only if we don't hit another ship and didn't go off the map)!
        
        //did we go off the map? is one of our tags divisible by 11? if so, NOT a valid placement
        
        var incrementedButtonTag = currentButtonTag
        
        for i in 1...engine.currentShipBeingPlaced.width-1 {
            if (incrementedButtonTag % 11) == 0 {
                isValidPlacement = false
                print("Not a valid placement of the ship")
            }
            
            
            
            incrementedButtonTag += 1
            
        }
        
        //check the rotation.......
        
        //need to check lower bounds now too
        
        
        let currentRotation = engine.currentShipBeingPlaced.rotation
        
        switch (currentRotation) {
        case 0:
            
            
            print("HI")
        default: print("lmao")
            
        }
        
        
        var incrementedXLocation = xCoordinate
        if (incrementedXLocation < 0) {
            incrementedXLocation = 0
        }
        
        for i in 1...engine.currentShipBeingPlaced.width {
            //print(engine.currentShipBeingPlaced.name)
            
            if (engine.player1Board[yCoordinate][incrementedXLocation] != "W") {
                print("Not a valid placement of the ship because of: " + engine.player1Board[yCoordinate][incrementedXLocation])
                isValidPlacement = false
            }
            
            if (incrementedXLocation < 10) {
                incrementedXLocation += 1
            }
        }
        
        /*
         
         
         //TODO: Make sure this works when I implement "H" for hit
         
         */
        
        //did we hit another ship??
        
        
        
        
        //print(engine.currentShipBeingPlaced.name)
        
        if (isValidPlacement) {
            //this will clear out all the previous ship cells
            
            removeShipFromView()
            
            sender.setImage(shipCell, forState: .Normal)
            buttonArray.append(sender)
            for i in 1...engine.currentShipBeingPlaced.width {
                
                //print(currentButtonTag)
                if let button = self.view.viewWithTag(currentButtonTag) as? UIButton
                {
                    buttonArray.append(button)
                    button.setImage(shipCell, forState: .Normal)
                }
                
                currentButtonTag += 1
            }
            
        }
        
        //ONLY UPDATE THE ACTUAL ARRAY WHEN WE PRESS CONFIRM!!!
        
    }
    
    let pickerData = ["-5", "-4", "-3", "-2", "-1", "0", "1", "2", "3", "4", "5"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpButtons()
        engine.setup()
        //TODO: Once the player is done placing all of their battleships, hide the "ship to place" label and UNHIDE all the aim based labels + fire button!
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

