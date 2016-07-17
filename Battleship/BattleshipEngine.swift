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
    
    var lastShotMissed = false
    var countOfAttemptsToBeSmart = 0
    var hitCount = 0
    var computersLastShotX = -1
    var computersLastShotY = -1
    var lastShotHit = false
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
            for i in 0...currentShipBeingPlaced.width {
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
        var Carrier = Ship(width: 5, rotation: 0, name: "Carrier")
        var Battleship = Ship(width: 4, rotation: 0, name: "Battleship")
        var Cruiser = Ship(width: 3, rotation: 0, name: "Cruiser")
        var Submarine = Ship(width: 3, rotation: 0, name: "Submarine")
        var Destroyer = Ship(width: 2, rotation: 0, name: "Destroyer")
        var Carrier2 = Ship(width: 5, rotation: 0, name: "Carrier")
        var Battleship2 = Ship(width: 4, rotation: 0, name: "Battleship")
        var Cruiser2 = Ship(width: 3, rotation: 0, name: "Cruiser")
        var Submarine2 = Ship(width: 3, rotation: 0, name: "Submarine")
        var Destroyer2 = Ship(width: 2, rotation: 0, name: "Destroyer")
        shipArray.append(Carrier)
        shipArray.append(Battleship)
        shipArray.append(Cruiser)
        shipArray.append(Submarine)
        shipArray.append(Destroyer)
        shipArray.append(Carrier2)
        shipArray.append(Battleship2)
        shipArray.append(Cruiser2)
        shipArray.append(Submarine2)
        shipArray.append(Destroyer2)
        
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
                for i in 1...ship.width {
                    player1Board[yLocation][xLocation] = ship.name
                    xLocation += 1
                }
            } else if currentShipBeingPlaced.rotation == 1 {
                for i in 1...ship.width {
                    player1Board[yLocation][xLocation] = ship.name
                    yLocation+=1
                }
            }
            
            
        }
        else {
            print("Placing ship: " + currentShipBeingPlaced.name)
            if currentShipBeingPlaced.rotation == 0 {
                for i in 1...ship.width {
                    player2Board[yLocation][xLocation] = ship.name
                    xLocation += 1
                }
            } else if currentShipBeingPlaced.rotation == 1 {
                for i in 1...ship.width {
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
    
    func computerFires() {
        //fire at a random location not fired at before... make smarter later (fires next to previous targets!)
        
        if !gameIsOver {
            var shotTaken = false
            
            
            
            
            while !shotTaken{
                
//                if (computersLastShotX == -1 || computersLastShotY == -1) {
//                    computersLastShotY = Int(arc4random_uniform(11))
//                    computersLastShotX = Int(arc4random_uniform(11))
//                }
//                
                var xNumber = Int(arc4random_uniform(11))
                var yNumber = Int(arc4random_uniform(11))
//                
//                var xNumber = 0
//                var yNumber = 0
//                
//                
//                //if we missed last time, shoot *far* away from there (i.e opposite quadrant)
//                
//                if lastShotHit == false {
//                    if (computersLastShotY < 6 && computersLastShotX < 6) {
//                        //second quad
//                        yNumber = computersLastShotY+5
//                        xNumber = computersLastShotX+5
//                    } else if (computersLastShotY > 5 && computersLastShotX > 5){
//                        //fourth quad
//                        yNumber = computersLastShotY-5
//                        xNumber = computersLastShotY-5
//                    } else if (computersLastShotY < 6 && computersLastShotX > 5) {
//                        //first quad
//                        yNumber = computersLastShotY + 5
//                        xNumber = computersLastShotX - 5
//                    } else if (computersLastShotY > 6 && computersLastShotX < 5) {
//                       //third quad
//                        yNumber = computersLastShotY - 5
//                        xNumber = computersLastShotX + 5
//                    } else {
//                        xNumber = Int(arc4random_uniform(11))
//                        yNumber = Int(arc4random_uniform(11))
//                    }
//                    
//                } else {
//                    //if we hit, try to shoot around that spot... keep track of how many times we've tried to hit that ship!
//                    
//                    if (countOfAttemptsToBeSmart < 5) {
//                        xNumber = Int(arc4random_uniform(11))
//                        yNumber = Int(arc4random_uniform(11))
//                    }
//                    
//                    countOfAttemptsToBeSmart += 1
//                }
//                
                
                if player1Board[xNumber][yNumber] == "M" || player1Board[xNumber][yNumber] == "H" {
                } else {
                    computersLastShotX = yNumber
                    computersLastShotY = xNumber
                    
                    fireAtLocation(yNumber, yLocation: xNumber)
                    
                    shotTaken = true
                    currentPlayer = 1
                    if player1Board[yNumber][xNumber] != "H" {
                        //computer missed last time... try shooting further away from this point!
                        lastShotMissed = true
                        lastShotHit = false
                    }
                    
                    if player1Board[yNumber][xNumber] == "H" {
                        lastShotHit = true
                    }
                    
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

