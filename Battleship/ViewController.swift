//
//  ViewController.swift
//  Battleship
//
//  Created by Sawyer Blatz on 6/25/16.
//  Copyright © 2016 Sawyer Blatz. All rights reserved.
//


//TODO: Reverse the order the ships display in
//TODO: Properly write vertical ships to memory


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
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var shipToPlaceText: UILabel!
    
    @IBAction func rotateButton(sender: UIButton) {
        if !buttonArray.isEmpty {
            var currentRotation = engine.currentShipBeingPlaced.rotation
            var currentButtonTag = buttonArray[0].tag
            let firstButton = buttonArray[0]
            let digit = buttonArray[0].currentTitle!
            var xCoordinate = 0
            var yCoordinate = 0
            
            if (sender.tag > 110) {
                // in the last row so the yCoordinate is just 10.
                xCoordinate = Int(digit.substringToIndex(digit.startIndex.advancedBy(1)))!
                yCoordinate = 10
                
            } else if (sender.tag % 11 == 0) {
                xCoordinate = 10
                yCoordinate = Int(digit.substringFromIndex(digit.endIndex.advancedBy(-1)))!
            }else {
                
                xCoordinate = Int(digit.substringToIndex(digit.startIndex.advancedBy(1)))!
                yCoordinate = Int(digit.substringFromIndex(digit.endIndex.advancedBy(-1)))!
                
            }
            
            switch (currentRotation) {
            case 0:
                //if this is legal...
                //if (11*engine.currentShipBeingPlaced.width + currentButtonTag < 121) {
                
                
                //rotate it, then check if it's legal. If it's not, unrotate it and do nothing.
                engine.currentShipBeingPlaced.rotation = 1
                
                if (isValidPlacementOfShip(firstButton)){
                    //in bounds... now does it hit another ship?
                    removeShipFromView()
                    buttonArray.removeAll()
                    if let theButton = self.view.viewWithTag(currentButtonTag) as? UIButton {
                        buttonArray.append(theButton)
                        theButton.setImage(shipCell, forState: .Normal)
                    }
                    
                    for i in 1...engine.currentShipBeingPlaced.width-1 {
                        currentButtonTag += 11
                        if let button = self.view.viewWithTag(currentButtonTag) as? UIButton
                        {
                            buttonArray.append(button)
                            button.setImage(shipCell, forState: .Normal)
                            
                            
                        }
                        
                        
                    }
                } else {
                    engine.currentShipBeingPlaced.rotation = 0
                }
                
                
            case 1:
                
                engine.currentShipBeingPlaced.rotation = 0
                if (isValidPlacementOfShip(firstButton)){
                    currentButtonTag = firstButton.tag
                    print(firstButton.tag)
                    //in bounds... now does it hit another ship?
                    removeShipFromView()
                    buttonArray.removeAll()
                    if let theButton = self.view.viewWithTag(currentButtonTag) as? UIButton {
                        buttonArray.append(theButton)
                        theButton.setImage(shipCell, forState: .Normal)
                    }
                    
                    for i in 1...engine.currentShipBeingPlaced.width-1 {
                        currentButtonTag += 1
                        if let button = self.view.viewWithTag(currentButtonTag) as? UIButton
                        {
                            buttonArray.append(button)
                            button.setImage(shipCell, forState: .Normal)
                            
                        }
                        
                        
                    }
                } else {
                    engine.currentShipBeingPlaced.rotation = 1
                }
                
                
            default:
                print("Nope")
            }
            
            
        }
        
    }
    
    
    func isValidPlacementOfShip(sender: UIButton) -> Bool {
        //check if the placement of the ship is valid or not
        
        
        
        let digit = sender.currentTitle!
        var xCoordinate = 0
        var yCoordinate = 0
        
        if (sender.tag > 110) {
            // in the last row so the yCoordinate is just 10.
            xCoordinate = Int(digit.substringToIndex(digit.startIndex.advancedBy(1)))!
            yCoordinate = 10
            
        } else if (sender.tag % 11 == 0) {
            xCoordinate = 10
            yCoordinate = Int(digit.substringFromIndex(digit.endIndex.advancedBy(-1)))!
        }else {
            
            xCoordinate = Int(digit.substringToIndex(digit.startIndex.advancedBy(1)))!
            yCoordinate = Int(digit.substringFromIndex(digit.endIndex.advancedBy(-1)))!
            
        }
        
        var currentButtonTag = sender.tag
        var incrementedButtonTag = currentButtonTag
        
        //check if the ship is going off the map... this changes based on the rotation!
        switch engine.currentShipBeingPlaced.rotation {
        case 0:
            
            //is the cellButton in the last row? If so we need to grab the whole "y" coordinate (e.g "10" not just one digit)
            
            
            for i in 1...engine.currentShipBeingPlaced.width-1 {
                if (incrementedButtonTag % 11) == 0 {
                    print("Not a valid placement of the ship")
                    return false
                }
                incrementedButtonTag += 1
                
            }        //horizontal ship
            
            var incrementedXLocation = xCoordinate
            if (incrementedXLocation < 0) {
                incrementedXLocation = 0
            }
            
            for i in 1...engine.currentShipBeingPlaced.width {
                //print(engine.currentShipBeingPlaced.name)
                
                if (engine.player1Board[yCoordinate][incrementedXLocation] != "W") {
                    print("Not a valid placement of the ship because of: " + engine.player1Board[yCoordinate][incrementedXLocation])
                    return false
                }
                
                if (incrementedXLocation < 10) {
                    incrementedXLocation += 1
                }
            }
            
            
            
            
        case 1:
            for i in 1...engine.currentShipBeingPlaced.width {
                if ((incrementedButtonTag > 110) && i != engine.currentShipBeingPlaced.width) {
                    print("Goes off bottom of the map")
                    return false
                }
                incrementedButtonTag+=11
            }
            
            var incrementedYLocation = yCoordinate
            
            for i in 1...engine.currentShipBeingPlaced.width {
                if (engine.player1Board[incrementedYLocation][xCoordinate] != "W") {
                    print("Not a valid placement of the ship because of: " + engine.player1Board[incrementedYLocation][xCoordinate])
                    return false
                }
                if (incrementedYLocation < 10) {
                    incrementedYLocation+=1
                }
            }
            
        //vertical ship
        default:
            return false
            //default?
        }
        
        
        //check if we hit another ship... do this no matter WHAT the rotation is!
        //TODO: Make sure this works when I implement "H" for hit
        
        return true
    }
    
    
    func removeShipFromView() {
        
        //this will clear out all the previous ship cells
        for buttons in buttonArray {
            if (buttons.tag == 6 || buttons.tag == 17 || buttons.tag == 28 || buttons.tag == 39 || buttons.tag == 50 || buttons.tag == 61 || buttons.tag == 72 || buttons.tag == 83 || buttons.tag == 94 || buttons.tag == 105 || buttons.tag == 116 || ((buttons.tag < 67) && (buttons.tag > 55)) ) {
                
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
        
        
        
        if !(buttonArray.isEmpty) {
            if (currElementInArray < 5) {
                currElementInArray += 1
                if (currElementInArray == 5) {
                    //Change the UI, it's time to start!
                    shipDescription.hidden = true
                    imageOfShip.hidden = true
                    shipToPlaceText.hidden = true
                    confirmButton.hidden = true
                    rotateButton.hidden = true
                    aimLabel.hidden = false
                    xCoordinateInput.hidden = false
                    yCoordinateInput.hidden = false
                    commaLabel.hidden = false
                    leftParenthLabel.hidden = false
                    rightParenthLabel.hidden = false
                    
                    
                    //check this range
                    for i in 1...120 {
                        if let button = self.view.viewWithTag(i) as? UIButton {
                            button
                            button.setImage(shipCell, forState: .Normal)
                        }
                    }
                    
                    engine.startGame()
                } else {
                    print("Registered confirm")
                    let digit = buttonArray[0].currentTitle!
                    
                    var xCoordinate = Int(digit.substringToIndex(digit.startIndex.advancedBy(1)))!
                    var yCoordinate = Int(digit.substringFromIndex(digit.endIndex.advancedBy(-1)))!
                    
                    
                    if (buttonArray[0].tag > 110) {
                        // in the last row so the yCoordinate is just 10.
                        xCoordinate = Int(digit.substringToIndex(digit.startIndex.advancedBy(1)))!
                        yCoordinate = 10
                        
                    } else if (buttonArray[0].tag % 11 == 0) {
                        xCoordinate = 10
                        yCoordinate = Int(digit.substringFromIndex(digit.endIndex.advancedBy(-1)))!
                    }else {
                        
                        xCoordinate = Int(digit.substringToIndex(digit.startIndex.advancedBy(1)))!
                        yCoordinate = Int(digit.substringFromIndex(digit.endIndex.advancedBy(-1)))!
                        
                    }
                    
                    
                    engine.placeShip(xCoordinate, yLocation: yCoordinate, ship: engine.currentShipBeingPlaced)
                    
                    
                    engine.printPlayer1Board()
                    
                    //wipe buttonArray on confirm.
                    buttonArray.removeAll()
                    
                    
                    var textArray = ["Destroyer - 2 spaces", "Submarine - 3 spaces", "Cruiser - 3 spaces", "Battleship - 4 spaces", "Carrier - 5 spaces", "No more ships to place :("]
                    
                    //textArray = textArray.reverse()
                    
                    let shipPicture = UIImage(named: engine.currentShipBeingPlaced.name + ".png")
                    
                    shipDescription.text = textArray[currElementInArray]
                    
                    imageOfShip.setImage(shipPicture, forState: .Normal)
                }
            }
        }
        //change the image of the ship and the description text
        
    }
    
    
    //TODO: Rotate Button!
    
    
    
    @IBAction func cellButton(sender: UIButton) {
        //our coordinates are told to us as 0,0 (top left) up to 10,10 (bottom right)
        //this function draws the ship on the screen in the corresponding cells based on its rotation as either vertical or horizontal.
        //this does not write anything to memory--only the confirm button does that
        
        
        var currentButtonTag = sender.tag
        
        if (isValidPlacementOfShip(sender)) {
            removeShipFromView()
            sender.setImage(shipCell, forState: .Normal)
            buttonArray.append(sender)
            
            if (engine.currentShipBeingPlaced.rotation == 0) {
                for i in 1...engine.currentShipBeingPlaced.width {
                    if let button = self.view.viewWithTag(currentButtonTag) as? UIButton {
                        buttonArray.append(button)
                        button.setImage(shipCell, forState: .Normal)
                    }
                    currentButtonTag += 1
                }
                
            } else if (engine.currentShipBeingPlaced.rotation == 1) {
                for i in 1...engine.currentShipBeingPlaced.width {
                    if let button = self.view.viewWithTag(currentButtonTag) as? UIButton {
                        buttonArray.append(button)
                        button.setImage(shipCell, forState: .Normal)
                    }
                    currentButtonTag += 11
                }
            }
        }
        
        
        
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

