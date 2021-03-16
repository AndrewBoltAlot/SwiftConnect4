//
//  BoardView.swift
//  Connect4
//
//  Created by Roisin Bolt on 16/03/2021.
//  Copyright © 2021 CS UCD. All rights reserved.
//


import UIKit

class BoardView: UIView {
    let boardToScreenRatio: CGFloat = 0.9
   // private var pieceBehaviour = Connect4PieceBehaviour()
    
    var originX: CGFloat = 5
    var originY: CGFloat = 70
    var squareSide: CGFloat = 40
    
    var boardPieces : Set<Connect4Piece> = Set<Connect4Piece>()
    var shadowVictory : Set<Connect4Piece> = Set<Connect4Piece>()
    

    override func draw(_ rect: CGRect) {
        let boardWidth = bounds.width * boardToScreenRatio
        squareSide = boardWidth / CGFloat(Connect4Game.cols)
        originX = (1 - boardToScreenRatio) * bounds.width / 2
        originY = (bounds.height - CGFloat(Connect4Game.rows) * squareSide) / 2
        drawBoard()
        drawPieces()
        
    }
    
    func columnAt(x: CGFloat) -> Int {
        return Int((x - originX) / squareSide)
    }
    
    func drawBoard() {
        UIColor.blue.setFill()
        let boardPath = UIBezierPath(roundedRect: CGRect(x: originX, y: originY, width: CGFloat(Connect4Game.cols) * squareSide, height: CGFloat(Connect4Game.rows) * squareSide), cornerRadius: 0.25 * squareSide)
        boardPath.stroke()
        boardPath.fill()
        
        UIColor.white.setFill()
        
        for row in 0..<Connect4Game.rows {
            for col in 0..<Connect4Game.cols {
                drawCircle(col: col, row: row, color: UIColor.white, highlight: false)
            }
        }
    }
    
    func drawPieces(){
        
        for piece in boardPieces {
            drawCircle(col: piece.col, row: piece.row, color: piece.isAlpha ? .red : .yellow, highlight: false)
        }
        for piece in shadowVictory {
            drawCircle(col: piece.col, row: piece.row, color: piece.isAlpha ? .red : .yellow, highlight: true )
        }
    }
    
    func drawCircle(col: Int, row: Int, color: UIColor, highlight: Bool){
        color.setFill()
        let circleCenterX: CGFloat = originX + 0.5 * squareSide + CGFloat(col) * squareSide
        let circleCenterY: CGFloat = originY +  0.5 * squareSide + CGFloat(row) * squareSide
        let circle = UIBezierPath(arcCenter: CGPoint(x: circleCenterX, y: circleCenterY), radius: 0.4 * squareSide, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        circle.fill()
       
        if highlight {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
            label.textColor = .black
            label.text = "1"
            //circle.apply(label)
            UIColor.green.setStroke()
            circle.lineWidth = 2
            circle.stroke()
        }
        
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
}
