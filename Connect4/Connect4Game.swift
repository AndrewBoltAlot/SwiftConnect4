//
//  Connect4Game.swift
//  ConnectFourPractice
//
//  Created by Roisin Bolt on 10/03/2021.
//

import Foundation
//MARK: - MODEL
struct Connect4Game {
    static let cols: Int = 7
    static let rows: Int = 6
    
    var pieces : Set<Connect4Piece> = Set<Connect4Piece>()
    var playerTurn: Bool = true
    
    //added reset function third
    mutating func reset(){
        pieces.removeAll()
    }
    
    //added gameover function fourth
    func gameOver(col:Int) -> Set<Connect4Piece>? {
        let row = Connect4Game.rows - numberOfPiecesAt(col: col)
        
        return connectFour(col: col, row: row, isRed: playerTurn)
       
    }
    // eight possible directions for the connect 4 victory
    func connectFour(col: Int, row: Int, isRed: Bool) -> Set<Connect4Piece>? {
        var horizontalBox: Set<Connect4Piece> = Set<Connect4Piece>()
        var verticalBox: Set<Connect4Piece> = Set<Connect4Piece>()
        var diagonalToptoBottom: Set<Connect4Piece> = Set<Connect4Piece>()
        var diagonalBottomtoTop: Set<Connect4Piece> = Set<Connect4Piece>()
        
        for i in 1...3{
            //Left Direction
            if let piece = pieceAt(col: col - i, row: row), piece.isAlpha == isRed {
                    horizontalBox.insert(piece)
            }
            if let piece = pieceAt(col: col - i, row: row + i), piece.isAlpha == isRed {
                diagonalToptoBottom.insert(piece)
            }
            if let piece = pieceAt(col: col, row: row + i), piece.isAlpha == isRed {
                verticalBox.insert(piece)
            }
            if let piece = pieceAt(col: col + i, row: row + i), piece.isAlpha == isRed {
                diagonalToptoBottom.insert(piece)
            }
            //Right Direction
            if let piece = pieceAt(col: col + i, row: row), piece.isAlpha == isRed {
                horizontalBox.insert(piece)
            }
            if let piece = pieceAt(col: col + i, row: row - i), piece.isAlpha == isRed {
                diagonalBottomtoTop.insert(piece)
            }
            if let piece = pieceAt(col: col, row: row - i), piece.isAlpha == isRed {
                verticalBox.insert(piece)
            }
            if let piece = pieceAt(col: col + i, row: row), piece.isAlpha == isRed {
                diagonalToptoBottom.insert(piece)
            }
            //Victory Condition
            if horizontalBox.count == 3 {
                horizontalBox.insert(pieceAt(col: col, row: row)!)
                return horizontalBox
            } else if verticalBox.count == 3 {
                verticalBox.insert(pieceAt(col: col, row: row)!)
                return verticalBox
            } else if diagonalToptoBottom.count == 3 {
                diagonalToptoBottom.insert(pieceAt(col: col, row: row)!)
                return diagonalToptoBottom
            } else if diagonalBottomtoTop.count == 3 {
                diagonalBottomtoTop.insert(pieceAt(col: col, row: row)!)
                return diagonalBottomtoTop
            }
            
        }
        
        return nil
    }
    
    //Added drop function second
    mutating func dropAt(col: Int) -> Bool {
        if numberOfPiecesAt(col: col) >= Connect4Game.rows {
            return false
        }
        
        let numberOfPieces = numberOfPiecesAt(col: col)
        let row = Connect4Game.rows - 1 - numberOfPieces //minus 1 because it starts at 0
        let newPiece = Connect4Piece(col: col, row: row, isAlpha: playerTurn ? false : true) //if player turn then isRed = false else true
        pieces.insert(newPiece)
        playerTurn = !playerTurn
        
        return true
    }
    
    func numberOfPiecesAt(col: Int) -> Int {
        var numberOfPieces: Int = 0
        
        for piece in pieces where piece.col == col {
            numberOfPieces += 1
        }
        return numberOfPieces
    }
    
    //Added this first
    func pieceAt(col: Int, row: Int) -> Connect4Piece? {
        for piece in pieces {
            if col == piece.col && row == piece.row {
                return piece
            }
        }
        return nil
    }
}
