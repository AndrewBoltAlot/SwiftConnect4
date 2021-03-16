//
//  ViewController.swift
//  Connect4
//
//  Created by COMP47390 on 09/01/2020.
//  Copyright © 2020 COMP47390. All rights reserved.
//

import UIKit

// Connect4 Framework with Deep Learning Bot
import Alpha0Connect4


class ViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var gameLabel: UILabel!
    
    // Play random game
    private func playGame() {
        // Game session
        let gameSession = GameSession()

        // Visualisation
        var board : [[String]] = Array(repeating: Array(repeating: " ", count: gameSession.boardLayout.columns), count: gameSession.boardLayout.rows)
        let printBoard = { (player: String, actions: [Int], piece: String) -> (String) in
            _ = actions.map {
                let row = $0 / gameSession.boardLayout.columns
                let column = $0 % gameSession.boardLayout.columns
                board[row][column] = piece
            }
            return "\(player)\n" + (board.map { $0.reduce("") { "\($0)|\($1)" } + "|" }).reduce("")  { "\($0)\n\($1)" } + "\n---------------\n"
        }

        // Play
        try! gameSession.clear()
        gameSession.botStarts = Int.random(in: 0...1) == 0
        DispatchQueue.global(qos: .userInitiated).async {
            if gameSession.botStarts {
                if let move = gameSession.move {
                    DispatchQueue.main.async {
                        self.gameLabel.text = printBoard("AlphaC4", [move.action], move.color == Color.red ? "X" : "O")
                    }
                }
                Thread.sleep(forTimeInterval: 0.38)
            }
            repeat {
                let column = Int.random(in: 0..<gameSession.boardLayout.columns)
                if gameSession.userPlay(at: column) {
                    if let move = gameSession.move {
                        DispatchQueue.main.async {
                            self.gameLabel.text = printBoard("Random", [move.action], move.color == Color.red ? "X" : "O")
                        }
                    }
                    Thread.sleep(forTimeInterval: 0.38)
                    if let move = gameSession.move {
                        DispatchQueue.main.async {
                            self.gameLabel.text = printBoard("AlphaC4", [move.action], move.color == Color.red ? "X" : "O")
                        }
                    }
                    Thread.sleep(forTimeInterval: 0.38)
                }
            } while !gameSession.done
            if let outcome = gameSession.outcome {
                DispatchQueue.main.async {
                    self.gameLabel.text = printBoard(outcome.message, outcome.winningPieces, ".")
                }
            }
        }
    }

    @IBOutlet var pathView: Connect4Pathview!
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var turnLbl: UILabel!
    var game: Connect4Game = Connect4Game()
    //private var pieceBehaviour = Connect4PieceBehaviour()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(_:)) )
        gestureRecognizer.delegate = self
        boardView.addGestureRecognizer(gestureRecognizer)
        displayPieces()
        // Do any additional setup after loading the view.
        let timer = Timer.scheduledTimer(withTimeInterval: 12, repeats: true) { _ in self.playGame() }
        timer.fire()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil){
        let fingerLoc = sender?.location(in: boardView)
        let col = boardView.columnAt(x: fingerLoc!.x)
        
        if game.dropAt(col: col) {
           // updateBoardView()
            if let victory = game.gameOver(col: col) {
                boardView.shadowVictory = victory
                boardView.setNeedsDisplay()
                turnLbl.text = game.playerTurn ? "Alpha0C4 Wins !!" : "Player Wins !!"
                boardView.isUserInteractionEnabled = false
            } else {
                updateBoardView()
            }
        }
    }
    
    func displayPieces(){
        boardView.boardPieces = game.pieces
        boardView.setNeedsDisplay()
    }
    
    @IBAction func reset(_ sender: Any) {
        game.reset()
       // boardView.boardPieces.removeAll()
        boardView.shadowVictory.removeAll()
        updateBoardView()
        boardView.isUserInteractionEnabled = true
    }
    
    func updateBoardView(){
        if game.playerTurn {
            turnLbl.text = "Player"
        } else {
            turnLbl.text = "Alpha0C4"
        }
        displayPieces()
    }


}



