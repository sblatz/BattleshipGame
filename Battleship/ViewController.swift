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

//extension UIImage {
//    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
//        let radiansToDegrees: (CGFloat) -> CGFloat = {
//            return $0 * (180.0 / CGFloat(M_PI))
//        }
//        let degreesToRadians: (CGFloat) -> CGFloat = {
//            return $0 / 180.0 * CGFloat(M_PI)
//        }
//        
//        // calculate the size of the rotated view's containing box for our drawing space
//        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
//        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
//        rotatedViewBox.transform = t
//        let rotatedSize = rotatedViewBox.frame.size
//        
//        // Create the bitmap context
//        UIGraphicsBeginImageContext(rotatedSize)
//        let bitmap = UIGraphicsGetCurrentContext()
//        
//        // Move the origin to the middle of the image so we will rotate and scale around the center.
//        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
//        
//        //   // Rotate the image context
//        CGContextRotateCTM(bitmap, degreesToRadians(degrees));
//        
//        // Now, draw the rotated/scaled image into the context
//        var yFlip: CGFloat
//        
//        if(flip){
//            yFlip = CGFloat(-1.0)
//        } else {
//            yFlip = CGFloat(1.0)
//        }
//        
//        CGContextScaleCTM(bitmap, yFlip, -1.0)
//        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
//        
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return newImage
//    }
//}


class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    private var engine = BattleshipEngine()
    
    let shipCell = UIImage(named: "ShipCell.png")
    let waterCell = UIImage(named: "WaterCell.png")
    let waterCellAxis = UIImage(named: "WaterCellAxis2.png")
    var imagesRotated = [UIImage]()
    var buttonsRotated = [UIButton]()
    
    //create an array of buttons so we can keep track of which ones have been colored grey
    var buttonArray = [UIButton]()
    
    @IBOutlet weak var theFireButton: UIButton!
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
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var controlPanelImage: UIImageView!
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    
    @IBAction func newGamePressed(sender: UIButton) {
        gameStatusLabel.text = " "
        currElementInArray = 0
        
        
        newGameButton.hidden = true
        shipDescription.hidden = false
        imageOfShip.hidden = false
        shipToPlaceText.hidden = false
        confirmButton.hidden = false
        rotateButton.hidden = false
        controlPanelImage.hidden = true
        xLabel.hidden = true
        yLabel.hidden = true
        //reset the visual board:
        
        for i in 0...320 {
            if let buttons = self.view.viewWithTag(i) as? UIButton {
                if (buttons.tag == 205 || buttons.tag == 216 || buttons.tag == 227 || buttons.tag == 238 || buttons.tag == 249 || buttons.tag == 260 || buttons.tag == 271 || buttons.tag == 282 || buttons.tag == 293 || buttons.tag == 304 || buttons.tag == 315 || ((buttons.tag < 266) && (buttons.tag > 254)) ) {
                    
                    buttons.setImage(waterCellAxis, forState: .Normal)
                } else if (buttons.tag == 6 || buttons.tag == 17 || buttons.tag == 28 || buttons.tag == 39 || buttons.tag == 50 || buttons.tag == 61 || buttons.tag == 72 || buttons.tag == 83 || buttons.tag == 94 || buttons.tag == 105 || buttons.tag == 116 || ((buttons.tag < 67) && (buttons.tag > 55)) ) {
                    
                    buttons.setImage(waterCellAxis, forState: .Normal)
                }
                else {
                    buttons.setImage(waterCell, forState: .Normal)
                }
                
                if buttons.tag < 200 {
                    buttons.userInteractionEnabled = true
                }
                
            }
        }
        
        engine.setup()
        let shipPicture = UIImage(named: engine.currentShipBeingPlaced.name + "White.png")
        shipDescription.text = "Carrier - 5 spaces"
        imageOfShip.setImage(shipPicture, forState: .Normal)
    }
    
    func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .Main, closure: () -> Void) {
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatchLevel.dispatchQueue, closure)
    }
    
    enum DispatchLevel {
        case Main, UserInteractive, UserInitiated, Utility, Background
        var dispatchQueue: OS_dispatch_queue {
            switch self {
            case .Main:             return dispatch_get_main_queue()
            case .UserInteractive:  return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
            case .UserInitiated:    return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
            case .Utility:          return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
            case .Background:       return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0) }
        }
    }
    
    @IBAction func fireButton(sender: UIButton) {
        print(xCoordinateInput.text)
        print(yCoordinateInput.text)
        if var xCoord = Int(yCoordinateInput.text!) {
            if var yCoord = Int(xCoordinateInput.text!) {
                
                yCoord += 5
                xCoord = 5-xCoord
                //                yCoord = 5-yCoord
                //                xCoord += 5
                
                print("Firing at: \(xCoord), \(yCoord)")
                engine.currentPlayer = 1
                var shipHit = engine.player2Board[xCoord][yCoord]
                engine.fireAtLocation(yCoord, yLocation: xCoord)
                self.updateView()
                
                
                if engine.player2Board[xCoord][yCoord] == "M" {
                    gameStatusLabel.text = "You missed."
                } else {
                    gameStatusLabel.text = "Nice shot!"
                    
                    var shipIsDead = true
                    //was this the opponent's last cell of that ship? if so... you sunk their ship!
                    for x in 0 ..< engine.player2Board.count {
                        for y in 0 ..< engine.player2Board[x].count {
                            if (engine.player2Board[x][y] == shipHit) {
                                shipIsDead = false
                                break
                            }
                        }
                    }
                    
                    if shipIsDead {
                        shipHit = (shipHit.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet()) as NSArray).componentsJoinedByString("")
                        gameStatusLabel.text = "You sunk the " + shipHit
                    }
                }
                
                
                
                
                delay(bySeconds: 1.5, dispatchLevel: .Main) {
                    self.gameStatusLabel.text = "Prepare for enemy fire!"
                }
                
                delay(bySeconds: 3, dispatchLevel: .Main) {
                    // delayed code that will run on background thread
                    self.engine.currentPlayer = 2
                    self.engine.computerFires()
                    self.gameStatusLabel.text = " "
                    self.updateView()
                }
                
                
                
                
            }
        }
        
    }
    
    
    @IBAction func rotateButton(sender: UIButton) {
        if !buttonArray.isEmpty {
            let currentRotation = engine.currentShipBeingPlaced.rotation
            var currentButtonTag = buttonArray[0].tag
            let firstButton = buttonArray[0]
            
            switch (currentRotation) {
            case 0:
                //if this is legal...
                //if (11*engine.currentShipBeingPlaced.width + currentButtonTag < 121) {
                
                
                //rotate it, then check if it's legal. If it's not, unrotate it and do nothing.
                engine.currentShipBeingPlaced.rotation = 1
                
                if (isValidPlacementOfShip(firstButton)){
                    gameStatusLabel.text = " "
                    //in bounds... now does it hit another ship?
                    removeShipFromView()
                    buttonArray.removeAll()
                    
                    cellButton(firstButton)
                    
                    /*
                     if let theButton = self.view.viewWithTag(currentButtonTag) as? UIButton {
                     buttonArray.append(theButton)
                     theButton.setImage(shipCell, forState: .Normal)
                     }
                     
                     for _ in 1...engine.currentShipBeingPlaced.width-1 {
                     currentButtonTag += 11
                     if let button = self.view.viewWithTag(currentButtonTag) as? UIButton
                     {
                     buttonArray.append(button)
                     button.setImage(shipCell, forState: .Normal)
                     
                     
                     }
                     
                     
                     }
                     */
                } else {
                    engine.currentShipBeingPlaced.rotation = 0
                }
                
                
            case 1:
                
                engine.currentShipBeingPlaced.rotation = 0
                if (isValidPlacementOfShip(firstButton)){
                    gameStatusLabel.text = " "
                    currentButtonTag = firstButton.tag
                    print(firstButton.tag)
                    //in bounds... now does it hit another ship?
                    removeShipFromView()
                    buttonArray.removeAll()
                    
                    cellButton(firstButton)
                    /*
                     if let theButton = self.view.viewWithTag(currentButtonTag) as? UIButton {
                     buttonArray.append(theButton)
                     theButton.setImage(shipCell, forState: .Normal)
                     }
                     
                     for _ in 1...engine.currentShipBeingPlaced.width-1 {
                     currentButtonTag += 1
                     if let button = self.view.viewWithTag(currentButtonTag) as? UIButton
                     {
                     buttonArray.append(button)
                     button.setImage(shipCell, forState: .Normal)
                     
                     }
                     
                     
                     }
                     */
                    
                } else {
                    engine.currentShipBeingPlaced.rotation = 1
                }
            default:
                print("Rotation error")
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
        
        let currentButtonTag = sender.tag
        var incrementedButtonTag = currentButtonTag
        
        //check if the ship is going off the map... this changes based on the rotation!
        switch engine.currentShipBeingPlaced.rotation {
        case 0:
            
            //is the cellButton in the last row? If so we need to grab the whole "y" coordinate (e.g "10" not just one digit)
            
            
            for _ in 1...engine.currentShipBeingPlaced.width-1 {
                if (incrementedButtonTag % 11) == 0 {
                    print("Not a valid placement.")
                    gameStatusLabel.text = "Not a valid placement."
                    return false
                }
                incrementedButtonTag += 1
                
            }        //horizontal ship
            
            var incrementedXLocation = xCoordinate
            if (incrementedXLocation < 0) {
                incrementedXLocation = 0
            }
            
            for _ in 1...engine.currentShipBeingPlaced.width {
                //print(engine.currentShipBeingPlaced.name)
                
                if (engine.player1Board[yCoordinate][incrementedXLocation] != "W") {
                    print("Not a valid placement of the ship because of: " + engine.player1Board[yCoordinate][incrementedXLocation])
                    gameStatusLabel.text = "Not a valid placement."
                    return false
                }
                
                if (incrementedXLocation < 10) {
                    incrementedXLocation += 1
                }
            }
            
            
            
            
        case 1:
            for i in 1...engine.currentShipBeingPlaced.width {
                if ((incrementedButtonTag > 110) && i != engine.currentShipBeingPlaced.width) {
                    gameStatusLabel.text = "Not a valid placement."
                    print("Goes off bottom of the map")
                    return false
                }
                incrementedButtonTag+=11
            }
            
            var incrementedYLocation = yCoordinate
            
            for _ in 1...engine.currentShipBeingPlaced.width {
                if (engine.player1Board[incrementedYLocation][xCoordinate] != "W") {
                    gameStatusLabel.text = "Not a valid placement."
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
                    
                    
                    //engine.printPlayer1Board()
                    
                    //wipe buttonArray on confirm.
                    buttonArray.removeAll()
                    
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
                    theFireButton.hidden = false
                    controlPanelImage.hidden = false
                    xLabel.hidden = false
                    yLabel.hidden = false
                    
                    //check this range
                    for i in 1...121 {
                        if let button = self.view.viewWithTag(i) as? UIButton {
                            button.userInteractionEnabled = false
                        }
                    }
                    print("Starting game!")
                    //engine.startGame()
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
                    
                    
                    //engine.printPlayer1Board()
                    
                    //wipe buttonArray on confirm.
                    buttonArray.removeAll()
                    
                    var textArray = ["Carrier - 5 spaces", "Battleship - 4 spaces", "Cruiser - 3 spaces", "Submarine - 3 Spaces", "Destroyer - 2 spaces", "No more ships to place :("]
                    //var textArray = ["Destroyer - 2 spaces", "Submarine - 3 spaces", "Cruiser - 3 spaces", "Battleship - 4 spaces", "Carrier - 5 spaces", "No more ships to place :("]
                    
                    //textArray = textArray.reverse()
                    
                    let shipPicture = UIImage(named: engine.currentShipBeingPlaced.name + "White.png")
                    
                    shipDescription.text = textArray[currElementInArray]
                    
                    imageOfShip.setImage(shipPicture, forState: .Normal)
                }
            }
        }
        //change the image of the ship and the description text
        
    }
    
    
    //TODO: Rotate Button!
    
    
    func isInDarkWater(button: UIButton) -> Bool {
        
        let buttons = button
        
        if (buttons.tag == 6 || buttons.tag == 17 || buttons.tag == 28 || buttons.tag == 39 || buttons.tag == 50 || buttons.tag == 61 || buttons.tag == 72 || buttons.tag == 83 || buttons.tag == 94 || buttons.tag == 105 || buttons.tag == 116 || ((buttons.tag < 67) && (buttons.tag > 55)) ) {
            return false
            
        }
        
        return true
    }
    
    
    @IBAction func cellButton(sender: UIButton) {
        //our coordinates are told to us as 0,0 (top left) up to 10,10 (bottom right)
        //this function draws the ship on the screen in the corresponding cells based on its rotation as either vertical or horizontal.
        //this does not write anything to memory--only the confirm button does that
        
        
        var currentButtonTag = sender.tag
        
        if (isValidPlacementOfShip(sender)) {
            gameStatusLabel.text = " "
            removeShipFromView()
            var shipCell = UIImage(named: "roundDarkLeft.png")
            
            if (!isInDarkWater(sender)) {
                //print("In light water")
                shipCell = UIImage(named: "roundLightLeft.png")
            }
            
            if sender.currentImage == "destroyerCell.png" {
                //("Is destroyer!")
            }
            
            if (engine.currentShipBeingPlaced.rotation == 0) {
                sender.setImage(shipCell, forState: .Normal)
                currentButtonTag += 1
                buttonArray.append(sender)
                for i in 1...engine.currentShipBeingPlaced.width-1 {
                    if let button = self.view.viewWithTag(currentButtonTag) as? UIButton {
                        if (i == engine.currentShipBeingPlaced.width-1) {
                            //last part of the ship. POINT it!
                            if (isInDarkWater(button)) {
                                //print(engine.currentShipBeingPlaced.name)
                                if (engine.currentShipBeingPlaced.name == "Destroyer") {
                                    shipCell = UIImage(named:"destroyerCell.png")
                                } else if (engine.currentShipBeingPlaced.name == "Submarine") {
                                    shipCell = UIImage(named:"roundDarkRight.png")
                                }
                                    
                                else {
                                    shipCell = UIImage(named: "shipCellPointDark.png")
                                    
                                }
                            }
                                
                            else {
                                if (engine.currentShipBeingPlaced.name == "Destroyer") {
                                    shipCell = UIImage(named:"destroyerCellLight.png")
                                } else if (engine.currentShipBeingPlaced.name == "Submarine") {
                                    shipCell = UIImage(named:"roundLightRight.png")
                                }
                                else {
                                    shipCell = UIImage(named: "shipCellPointLight.png")
                                }
                            }
                        } else {
                            shipCell = UIImage(named: "ShipCell.png")
                        }
                        
                        
                        //remove us from the rotated buttons list...
                        //print(buttonsRotated.count)
                        for i in 0...buttonsRotated.count {
                            if (i < buttonsRotated.count)  {
                                //print ("in here")
                                let otherButton = buttonsRotated[i]
                                if button.tag == otherButton.tag {
                                    buttonsRotated.removeAtIndex(i)
                                }
                            }
                            
                        }
                        buttonArray.append(button)
                        button.setImage(shipCell, forState: .Normal)
                    }
                    currentButtonTag += 1
                }
                
            } else if (engine.currentShipBeingPlaced.rotation == 1) {
                if isInDarkWater(sender) {
                    shipCell = UIImage(named: "roundDarkUp.png")
                } else {
                    shipCell = UIImage(named: "roundLightUp.png")
                }
                sender.setImage(shipCell, forState: .Normal)
                buttonArray.append(sender)
                currentButtonTag  += 11
                for i in 1...engine.currentShipBeingPlaced.width-1 {
                    if let button = self.view.viewWithTag(currentButtonTag) as? UIButton {
                        if (i == engine.currentShipBeingPlaced.width-1) {
                            //last part of the ship. POINT it!
                            if (isInDarkWater(button)) {
                                print(engine.currentShipBeingPlaced.name)
                                if (engine.currentShipBeingPlaced.name == "Destroyer") {
                                    shipCell = UIImage(named:"destroyerDown.png")
                                } else if (engine.currentShipBeingPlaced.name == "Submarine") {
                                    shipCell = UIImage(named:"roundDarkDown.png")
                                }
                                    
                                else {
                                    shipCell = UIImage(named: "shipCellPointDarkDown.png")
                                    
                                }
                            }
                                
                            else {
                                if (engine.currentShipBeingPlaced.name == "Destroyer") {
                                    shipCell = UIImage(named:"destroyerCellLightDown.png")
                                } else if (engine.currentShipBeingPlaced.name == "Submarine") {
                                    shipCell = UIImage(named:"roundLightDown.png")
                                }
                                else {
                                    shipCell = UIImage(named: "shipCellPointLightDown.png")
                                    
                                }
                            }
                        } else {
                            shipCell = UIImage(named: "ShipCell.png")
                        }
                        
                        
                        currentButtonTag += 11
                        buttonArray.append(button)
                        //append us to the list of buttons rotated...
                        buttonsRotated.append(button)
                        //print(shipCell)
                        button.setImage(shipCell, forState: .Normal)
                    }
                }
            }
        }
        
        
        
    }
    
    let pickerData = ["5", "4", "3", "2", "1", "0", "-1", "-2", "-3", "-4", "-5"]
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        controlPanelImage.hidden = true
        theFireButton.hidden = true
        newGameButton.hidden = true
        xLabel.hidden = true
        yLabel.hidden = true
        
        setUpButtons()
        engine.setup()
        //TODO: Once the player is done placing all of their battleships, hide the "ship to place" label and UNHIDE all the aim based labels + fire button!
    }
    
    func setUpButtons() {
        var picker: UIPickerView
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
    
    
    func updateView() {
        //check to see if we've been hit anywhere or if the computer has
        //engine.printPlayer1Board()
        //loop through our board, wherever there's an "H" put a fire, wherever there's an "M" put a circle
        
        let smokeImageDark = UIImage(named: "smokeDarkWater.png")
        let smoke = UIImage(named: "smoke.png")
        var fireImage = UIImage(named: "lol.png")
        for x in 0 ..< engine.player1Board.count {
            for y in 0 ..< engine.player1Board[x].count {
                
                if(engine.player1Board[x][y] == "H") {
                    let theTag = 11*x + y + 1 //is this the correct calculation or flipped?
                    if let theButton = self.view.viewWithTag(theTag) as? UIButton {
                        fireImage = theButton.currentImage
                        //does it need to be a rounded fire?
                        
                        //print(theTag)
                        if theButton.currentImage!.isEqual(UIImage(named: "destroyerCell.png")) {
                            fireImage = UIImage(named: "DestroyerFireDark.png")
                        } else if theButton.currentImage!.isEqual(UIImage(named: "destroyerDown.png")) {
                            fireImage = UIImage(named: "DestroyerFireDarkDown.png")
                            
                        } else if theButton.currentImage!.isEqual(UIImage(named: "destroyerCellLight.png")) {
                            fireImage = UIImage(named: "destroyerCellFireLight.png")
                            
                        } else if theButton.currentImage!.isEqual(UIImage(named: "destroyerCellLightDown.png")) {
                            fireImage = UIImage(named: "DestroyerFireLightDown.png")
                            
                        } else if theButton.currentImage!.isEqual(UIImage(named: "roundDarkLeft.png")) {
                            fireImage = UIImage(named: "fireRoundDark.png")
                        } else if theButton.currentImage!.isEqual(UIImage(named: "roundDarkRight.png")) {
                            fireImage = UIImage(named: "fireRoundDarkRight.png")
                            
                        }else if theButton.currentImage!.isEqual(UIImage(named: "roundDarkDown.png")) {
                            fireImage = UIImage(named: "fireRoundDarkDown.png")
                            
                        }else if theButton.currentImage!.isEqual(UIImage(named: "roundDarkUp.png")) {
                            fireImage = UIImage(named: "fireRoundDarkUp.png")
                            
                        }else if theButton.currentImage!.isEqual(UIImage(named: "roundLightLeft.png")) {
                            fireImage = UIImage(named: "fireRoundLightLeft.png")
                            
                        }else if theButton.currentImage!.isEqual(UIImage(named: "roundLightRight.png")) {
                            fireImage = UIImage(named: "fireRoundLightRight.png")
                            
                        }else if theButton.currentImage!.isEqual(UIImage(named: "roundLightDown.png")) {
                            fireImage = UIImage(named: "fireRoundLightDown.png")
                            
                        }else if theButton.currentImage!.isEqual(UIImage(named: "roundLightUp.png")) {
                            fireImage = UIImage(named: "fireRoundLightUp.png")
                            
                        }
                        
                        
                        else if theButton.currentImage!.isEqual(UIImage(named: "shipCellPointDark.png")) {
                            fireImage = UIImage(named: "firePointDark.png")

                        } else if theButton.currentImage!.isEqual(UIImage(named: "shipCellPointDarkDown.png")) {
                            fireImage = UIImage(named: "firePointDarkDown.png")
                            
                        }
                        else if theButton.currentImage!.isEqual(UIImage(named: "shipCellPointLight.png")) {
                            fireImage = UIImage(named: "firePointLight.png")
                        }else if theButton.currentImage!.isEqual(UIImage(named: "shipCellPointLightDown.png")) {
                            fireImage = UIImage(named: "firePointLightDown.png")
                        }
                        else if theButton.currentImage!.isEqual(UIImage(named: "ShipCell.png")) {
                            fireImage = UIImage(named: "fireCell.png")
                        }
                        
                        
                
                        
                        
                        //JUMP HERE
                      
                        
                        //print("setting image!")
                        theButton.setImage(fireImage, forState: .Normal)
                    }
                    
                }
                
                if (engine.player1Board[x][y] == "M") {
                    let theTag = 11*x + y + 1
                    if let buttons = self.view.viewWithTag(theTag) as? UIButton {
                        
                        if (buttons.tag == 6 || buttons.tag == 17 || buttons.tag == 28 || buttons.tag == 39 || buttons.tag == 50 || buttons.tag == 61 || buttons.tag == 72 || buttons.tag == 83 || buttons.tag == 94 || buttons.tag == 105 || buttons.tag == 116 || ((buttons.tag < 67) && (buttons.tag > 55)) ) {
                            
                            buttons.setImage(smoke, forState: .Normal)
                            
                        } else {
                            buttons.setImage(smokeImageDark, forState: .Normal)
                            
                        }
                    }
                }
            }
        }
        
        for x in 0 ..< engine.player2Board.count {
            for y in 0 ..< engine.player2Board[x].count {
                if(engine.player2Board[x][y] == "H") {
                    let theTag = 11*x + y + 200 //is this the correct calculation or flipped?
                    if let theButton = self.view.viewWithTag(theTag) as? UIButton {
                        fireImage = UIImage(named: "fireCell.png")
                        theButton.setImage(fireImage, forState: .Normal)
                    }
                    
                }
                
                if (engine.player2Board[x][y] == "M") {
                    let theTag = 11*x + y + 200
                    if let buttons = self.view.viewWithTag(theTag) as? UIButton {
                        
                        //TODO: FIX THESE ONES
                        if (buttons.tag == 205 || buttons.tag == 216 || buttons.tag == 227 || buttons.tag == 238 || buttons.tag == 249 || buttons.tag == 260 || buttons.tag == 271 || buttons.tag == 282 || buttons.tag == 293 || buttons.tag == 304 || buttons.tag == 315 || ((buttons.tag < 266) && (buttons.tag > 254)) ) {
                            
                            buttons.setImage(smoke, forState: .Normal)
                            
                        } else {
                            buttons.setImage(smokeImageDark, forState: .Normal)
                            
                        }
                    }
                }
                
            }
        }
        
        
        //is the game over?
        if engine.gameIsOver {
            //remove the firing interface and replace with a button that allows the game to be started from the beginning
            if engine.winningPlayer == 1 {
                gameStatusLabel.text = "You won!"
            } else {
                gameStatusLabel.text = "The computer won!"
            }
            newGameButton.hidden = false
            aimLabel.hidden = true
            xCoordinateInput.text = ""
            yCoordinateInput.text = ""
            xCoordinateInput.hidden = true
            yCoordinateInput.hidden = true
            commaLabel.hidden = true
            leftParenthLabel.hidden = true
            rightParenthLabel.hidden = true
            theFireButton.hidden = true
            xLabel.hidden = true
            yLabel.hidden = true
        }
        
    }
    
}

