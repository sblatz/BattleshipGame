//
//  BattleshipEngine.swift
//  Battleship
//
//  Created by Sawyer Blatz on 6/26/16.
//  Copyright © 2016 Sawyer Blatz. All rights reserved.
//

import Foundation


class Ship {
    var width = 0
    var hitsTaken = 0
    var rotation = 0
    var name = ""
    
    
    init(width: Int,rotation: Int, name: String) {
        self.width = width
        self.rotation = rotation
        self.name = name
    }
}


class BattleshipEngine {
    var firstShotForTesting = false
    
    var countOfAttemptsToBeSmart = 0
    var hitCount = 0
    var previouslyTrackedShip = " "
    var computersLastShotX = -1
    var computersLastShotY = -1
    var lastShotHit = false
    var lastShipHitRotation = 0
    var lastShipHit = " "
    var trackingShip = false
    var secondHit = false
    
    //var player1Board = [[String]]()
    var player1Board = [[String]](count: 11, repeatedValue: [String](count: 11, repeatedValue: "W"))
    //arr[0][1] = 1
    var player2Board = [[String]](count: 11, repeatedValue: [String](count: 11, repeatedValue: "W"))
    var winningPlayer = -1
    var gameIsOver = false
    
    
    //dimensions of the sea:
    let xLen = 11
    let yLen = 11
    
    //players -- this means we have two boards we have to keep track of
    let player1 = 1
    let player2 = 2
    var currentPlayer = 1
    
    
    
    
    var shipArray = [Ship]()
    var currentIndex = 0
    
    
    var currentShipBeingPlaced: Ship {
        return shipArray[currentIndex]
    }
    
    //    func startGame() {
    //        // create the computer's board
    //        print("Starting Game!")
    //
    //        //createComputerBoard()
    //
    //        currentPlayer = 1
    //
    //    }
    
    
    
    func createComputerBoard() {
        //place ships...albeit rather inefficiently
        currentPlayer = 2
        var shipsPlaced = 0
        while (shipsPlaced < 5) {
            print(currentShipBeingPlaced.name)
            let xNumber = Int(arc4random_uniform(11))
            let yNumber = Int(arc4random_uniform(11))
            let rotation = Int(arc4random_uniform(2))
            var validPlacement = true
            currentShipBeingPlaced.rotation = rotation
            //check if it's a valid placement before placing it.
            var currentX = xNumber
            var currentY = yNumber
            for _ in 0...currentShipBeingPlaced.width {
                if rotation == 0 {
                    if currentX > 10 {
                        validPlacement = false
                        break
                    }
                    if player2Board[currentY][currentX] != "W" {
                        validPlacement = false
                        break
                    }
                    currentX += 1
                } else {
                    if currentY > 10 {
                        validPlacement = false
                        break
                    }
                    if player2Board[currentY][currentX] != "W" {
                        validPlacement = false
                        break
                    }
                    currentY += 1
                }
                
                
            }
            
            if validPlacement == true {
                print("Putting ship at: \(yNumber), \(xNumber)")
                
                placeShip(xNumber, yLocation: yNumber, ship: currentShipBeingPlaced)
                shipsPlaced += 1
            }
        }
        printPlayer2Board()
    }
    
    func setup() {
        gameIsOver = false
        shipArray.removeAll()
        player2Board.removeAll()
        player1Board.removeAll()
        currentPlayer = 2
        currentIndex = 0
        player1Board = [[String]](count: 11, repeatedValue: [String](count: 11, repeatedValue: "W"))
        player2Board = [[String]](count: 11, repeatedValue: [String](count: 11, repeatedValue: "W"))
        let Carrier2 = Ship(width: 5, rotation: 0, name: "Carrier2")
        let Battleship2 = Ship(width: 4, rotation: 0, name: "Battleship2")
        let Cruiser2 = Ship(width: 3, rotation: 0, name: "Cruiser2")
        let Submarine2 = Ship(width: 3, rotation: 0, name: "Submarine2")
        let Destroyer2 = Ship(width: 2, rotation: 0, name: "Destroyer2")
        let Carrier = Ship(width: 5, rotation: 0, name: "Carrier")
        let Battleship = Ship(width: 4, rotation: 0, name: "Battleship")
        let Cruiser = Ship(width: 3, rotation: 0, name: "Cruiser")
        let Submarine = Ship(width: 3, rotation: 0, name: "Submarine")
        let Destroyer = Ship(width: 2, rotation: 0, name: "Destroyer")
        shipArray.append(Carrier2)
        shipArray.append(Battleship2)
        shipArray.append(Cruiser2)
        shipArray.append(Submarine2)
        shipArray.append(Destroyer2)

        shipArray.append(Carrier)
        shipArray.append(Battleship)
        shipArray.append(Cruiser)
        shipArray.append(Submarine)
        shipArray.append(Destroyer)
        
        //ask the player to place their first ship
        print("Please place your first ship")
        createComputerBoard()
        currentPlayer = 1
    }
    
    
    
    func placeShip(xLocation:Int, yLocation: Int, ship: Ship) {
        //place the ship's leftmost end at this location on the active player's board.
        var xLocation = xLocation
        var yLocation = yLocation
        if currentPlayer == 1 {
            
            
            if currentShipBeingPlaced.rotation == 0 {
                for _ in 1...ship.width {
                    player1Board[yLocation][xLocation] = ship.name
                    xLocation += 1
                }
            } else if currentShipBeingPlaced.rotation == 1 {
                for _ in 1...ship.width {
                    player1Board[yLocation][xLocation] = ship.name
                    yLocation+=1
                }
            }
            
            
        }
        else {
            print("Placing ship: " + currentShipBeingPlaced.name)
            if currentShipBeingPlaced.rotation == 0 {
                for _ in 1...ship.width {
                    player2Board[yLocation][xLocation] = ship.name
                    xLocation += 1
                }
            } else if currentShipBeingPlaced.rotation == 1 {
                for _ in 1...ship.width {
                    player2Board[yLocation][xLocation] = ship.name
                    yLocation+=1
                }
            }
        }
        
        currentIndex += 1
        
        //changeCurrentPlayer()
        
        
    }
    
    func printPlayer1Board() {
        for x in 0 ..< player1Board.count {
            for y in 0 ..< player1Board[x].count {
                print(player1Board[x][y])
            }
        }
        
    }
    
    func printPlayer2Board() {
        for x in 0 ..< player2Board.count {
            for y in 0 ..< player2Board[x].count {
                print(player2Board[x][y])
            }
        }
        
    }
    
    func fireAtLocation(xLocation: Int, yLocation: Int) {
        //shoot at enemy
        
        if currentPlayer == 1 {
            //place an X on opponent's board if it's a ship (and tell use we hit). Otherwise place an O
            if player2Board[yLocation][xLocation] != "W" &&
                player2Board[yLocation][xLocation] != "M" &&
                player2Board[yLocation][xLocation] != "H" {
                //we hit a ship!
                player2Board[yLocation][xLocation] = "H"
            } else if player2Board[yLocation][xLocation] == "W"{
                player2Board[yLocation][xLocation] = "M"
            }
            
            currentPlayer = 2
        } else {
            print("Computer firing!")
            if player1Board[yLocation][xLocation] != "W" && player1Board[yLocation][xLocation] != "M" &&
                player1Board[yLocation][xLocation] != "H" {
                
                player1Board[yLocation][xLocation] = "H"
            } else if player1Board[yLocation][xLocation] == "W"{
                player1Board[yLocation][xLocation] = "M"
                
            }
            currentPlayer = 1
        }
        
        //computerFires()
        //printPlayer1Board()
        
        //changeCurrentPlayer()
        checkForWin()
    }
    
    func getShipFromName(name: String) -> Ship {
        
        for theShip in shipArray {
            if theShip.name == name {
                return theShip
            }
        }
        
        print("Couldn't find the specified ship... defaulting to 0th element!")
        return shipArray[0]
    }
    
    func computerFires() {
        
        if !gameIsOver {
            
            var shotTaken = false
            var coinFlip = 0
            
            var retryAttempt = 0
            while !shotTaken{
                retryAttempt += 1
                if (computersLastShotX == -1 || computersLastShotY == -1) {
                    computersLastShotY = Int(arc4random_uniform(11))
                    computersLastShotX = Int(arc4random_uniform(11))
                }
                
                var xNumber = Int(arc4random_uniform(11))
                var yNumber = Int(arc4random_uniform(11))
                
                
                
                if (firstShotForTesting == true) {
                    for x in 0 ..< player1Board.count {
                        for y in 0 ..< player1Board[x].count {
                            if (player1Board[x][y] == "Carrier") {
                                print(player1Board[x][y])
                                xNumber = x
                                yNumber = y - 2
                                computersLastShotX = xNumber
                                computersLastShotY = yNumber
                            }
                        }
                        
                        firstShotForTesting = false
                    }
                }
                
                coinFlip = Int(arc4random_uniform(2))
                if lastShotHit == false && trackingShip == false {
                    
                    coinFlip = Int(arc4random_uniform(5))
                        //1 in 10 chance to fire back at a previouslyTrackedShip
                    
                    if (coinFlip == 0) {
                        for x in 0 ..< player1Board.count {
                            for y in 0 ..< player1Board[x].count {
                                if player1Board[x][y] == previouslyTrackedShip {
                                    print("Using my intuition to fire at a spot that may be a ship...")
                                    xNumber = x
                                    yNumber = y
                                }
                            }
                        }

                    }
                    
                } else {
                    trackingShip = true
                    
                    //if it's the second shot that has HIT, then it should just continue in a straight line
                    
                    xNumber = -1
                    yNumber = -1
                    
                    print("Tracking a ship...")
                    
                    
                    
                    
                    if (secondHit == true) {
                        
                        print("We know the orientation now: " + String(lastShipHitRotation))
                        coinFlip = Int(arc4random_uniform(2))
                        if lastShipHitRotation == 0 {
                            if (coinFlip == 0) {
                                if (computersLastShotY + 1 <= 10) {
                                    print("adding a x")
                                    xNumber = computersLastShotX
                                    yNumber = computersLastShotY+1
                                    
                                }
                            } else {
                                if(computersLastShotY - 1 >= 0) {
                                    print("subtracting a x")
                                    xNumber = computersLastShotX
                                    yNumber = computersLastShotY-1
                                    
                                }
                            }
                            
                        } else {
                            if (coinFlip == 0) {
                                if (computersLastShotX + 1 <= 10) {
                                    print("adding a y")
                                    xNumber = computersLastShotX+1
                                    yNumber = computersLastShotY
                                }
                            } else {
                                if computersLastShotX - 1 >= 0 {
                                    print("subtracting a y")
                                    xNumber = computersLastShotX-1
                                    yNumber = computersLastShotY
                                }
                                
                            }
                        }
                    } else {
                        
                        
                        
                        
                        if (coinFlip == 0) {
                            print("coinFlip 0")
                            
                            coinFlip = Int(arc4random_uniform(2))
                            if (coinFlip == 0) {
                                if (computersLastShotY + 1 <= 10) {
                                    print("adding a y")
                                    xNumber = computersLastShotX
                                    yNumber = computersLastShotY+1
                                    
                                } else if(computersLastShotY - 1 >= 0) {
                                    print("subtracting a y")
                                    xNumber = computersLastShotX
                                    yNumber = computersLastShotY-1
                                    
                                }
                                
                            } else {
                                if(computersLastShotY - 1 >= 0) {
                                    print("subtracting a y")
                                    xNumber = computersLastShotX
                                    yNumber = computersLastShotY-1
                                    
                                } else if (computersLastShotY + 1 <= 10) {
                                    print("adding a y")
                                    xNumber = computersLastShotX
                                    yNumber = computersLastShotY+1
                                    
                                }
                            }
                            
                        } else {
                            coinFlip = Int(arc4random_uniform(2))
                            
                            print("coinFlip 1")
                            
                            if (coinFlip == 0) {
                                if (computersLastShotX + 1 <= 10) {
                                    print("adding a x")
                                    xNumber = computersLastShotX+1
                                    yNumber = computersLastShotY
                                } else if computersLastShotX - 1 >= 0 {
                                    print("subtracting a x")
                                    xNumber = computersLastShotX-1
                                    yNumber = computersLastShotY
                                }
                            } else {
                                if computersLastShotX - 1 >= 0 {
                                    print("subtracting a x")
                                    xNumber = computersLastShotX-1
                                    yNumber = computersLastShotY
                                } else if (computersLastShotX + 1 <= 10) {
                                    print("adding a x")
                                    xNumber = computersLastShotX+1
                                    yNumber = computersLastShotY
                                }
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                    }
                    
                    var shipStillAlive = false
                    
                    for x in 0 ..< player1Board.count {
                        for y in 0 ..< player1Board[x].count {
                            if player1Board[x][y] == lastShipHit {
                                shipStillAlive = true
                            }
                        }
                    }

                    
                    //are we surrounded by hits/misses? // have we failed to hit 20 times in a row...? odds are we're stuck. Stop tracking and go random
                    
                  
                    
                    
                    //(secondHit && (player1Board[xNumber][yNumber] == "M" || player1Board[xNumber][yNumber] == "H")) ||
                    
                    if (xNumber == -1 || yNumber == -1 || shipStillAlive == false
                        || (secondHit && lastShotHit == false) || retryAttempt > 30) {
                        
                        if (retryAttempt > 30) {
                            print("I'm stuck... fixing self...")
                        }
                        
                        if (shipStillAlive == true) {
                            previouslyTrackedShip = lastShipHit
                        }
                        trackingShip = false
                        print("No longer tracking")
                        secondHit = false
                    }
                                       
                    if xNumber == -1 || yNumber == -1 {
                        secondHit = false
                        trackingShip = false
                        xNumber = Int(arc4random_uniform(11))
                        yNumber = Int(arc4random_uniform(11))

                    }
                    
                    
                }
                
                
                if player1Board[xNumber][yNumber] == "M" || player1Board[xNumber][yNumber] == "H" {
                } else {
                    
                    if (trackingShip == true) {
                        
                    } else {
                        
                        //only change this if we're no longer tracking a ship && we miss
                        
                        computersLastShotX = xNumber
                        computersLastShotY = yNumber
                    }
                    
                    if player1Board[xNumber][yNumber] != "M" && player1Board[xNumber][yNumber] != "W" {
                        
                        if (trackingShip == true && player1Board[xNumber][yNumber] == lastShipHit) {
                            //only a second hit if it's on the same ship we're already tracking!
                            secondHit = true
                        }
                        
                        lastShipHit = player1Board[xNumber][yNumber]
                        lastShipHitRotation = getShipFromName(lastShipHit).rotation
                        print("Computer hit ship: " + lastShipHit)
                        lastShotHit = true
                        computersLastShotX = xNumber
                        computersLastShotY = yNumber
                        trackingShip = true
                    } else {
                        if (secondHit == true || trackingShip == false) {
                            lastShotHit = false
                        }
                    }
                    
                    fireAtLocation(yNumber, yLocation: xNumber)
                    
                    shotTaken = true
                    currentPlayer = 1
                    
                }
            }
        }
    }
    
    func checkForWin() {
        hitCount = 0
        for x in 0 ..< player1Board.count {
            for y in 0 ..< player1Board[x].count {
                if(player1Board[x][y] != "H" && player1Board[x][y] != "M" && player1Board[x][y] != "W") {
                    //there are still ships on my side... play on!
                    hitCount += 1
                } else {
                    
                }
            }
        }
        
        if hitCount == 0 {
            print("Player 2 has won!")
            winningPlayer = 2
            gameIsOver = true
        } else {
            hitCount = 0
        }
        
        
        for x in 0 ..< player2Board.count {
            for y in 0 ..< player2Board[x].count {
                if (player2Board[x][y] != "H" && player2Board[x][y] != "M" && player2Board[x][y] != "W") {
                    hitCount += 1
                } else {
                }
            }
        }
        if hitCount == 0 {
            print("Player 1 has won!")
            winningPlayer = 1
            gameIsOver = true
        }
    }
    
    func changeCurrentPlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
    }
    
}

