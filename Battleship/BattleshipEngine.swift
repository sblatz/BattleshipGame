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

    
    //the game's current state:
    var currentGameState = "Setup"

    
    //var player1Board = [[String]]()
    var player1Board = [[String]](count: 11, repeatedValue: [String](count: 11, repeatedValue: "W"))
    //arr[0][1] = 1
    var player2Board = [[String]]()
    
    
    
    //dimensions of the sea:
    let xLen = 10
    let yLen = 10
    
    //players -- this means we have two boards we have to keep track of
    let player1 = 1
    let player2 = 2
    var currentPlayer = 1
    
    
    var Destroyer = Ship(width: 2, rotation: 0, name: "Destroyer")
    var Submarine = Ship(width: 3, rotation: 0, name: "Submarine")
    var Cruiser = Ship(width: 3, rotation: 0, name: "Cruiser")
    var Battleship = Ship(width: 4, rotation: 0, name: "Battleship")
    var Carrier = Ship(width: 5, rotation: 0, name: "Carrier")
    var Destroyer2 = Ship(width: 2, rotation: 0, name: "Destroyer")
    var Submarine2 = Ship(width: 3, rotation: 0, name: "Submarine")
    var Cruiser2 = Ship(width: 3, rotation: 0, name: "Cruiser")
    var Battleship2 = Ship(width: 4, rotation: 0, name: "Battleship")
    var Carrier2 = Ship(width: 5, rotation: 0, name: "Carrier")
    
    var shipArray = [Ship]()
    var currentIndex = 0
    
    
    var currentShipBeingPlaced: Ship {
        return shipArray[currentIndex]
    }
    
    func setup() {
        currentPlayer = 1
        shipArray.append(Destroyer)
        shipArray.append(Submarine)
        shipArray.append(Cruiser)
        shipArray.append(Battleship)
        shipArray.append(Carrier)
        shipArray.append(Destroyer2)
        shipArray.append(Submarine2)
        shipArray.append(Cruiser2)
        shipArray.append(Battleship2)
        shipArray.append(Carrier2)
        //ask the player to place their first ship
        print("Please place your first ship")
        
        //Get the current text on the "place" coordinates to determine where the ship should be placed
    }

    

    //placeShip once we press "Confirm", then advance the currentShipBeingPlaced
    
    func placeShip(xLocation:Int, yLocation: Int, ship: Ship) {
        //place the ship's leftmost end at this location on the active player's board.
        var xLocation = xLocation
        
        if currentPlayer == 1 {
        
        
        for i in 1...ship.width {
            player1Board[yLocation][xLocation] = ship.name
            xLocation += 1
        }
            
        }
        else {
            for i in 0...ship.width {
                player2Board[yLocation][xLocation] = ship.name
                xLocation += 1
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
    
    func fireAtLocation(xLocation: Int, yLocation: Int) {
        //shoot at enemy
        if currentPlayer == 1 {
            //place an X on opponent's board if it's a ship (and tell use we hit). Otherwise place an O
            
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

