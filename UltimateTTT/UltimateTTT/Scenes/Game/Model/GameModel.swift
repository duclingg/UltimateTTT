//
//  GameModel.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import Foundation

enum Player: String {
    case p1 = "X"
    case p2 = "O"
    
    var opponent: Player {
        return self == .p1 ? .p2 : .p1
    }
}

class GameModel: ObservableObject {
    @Published var squares: [Player?] = Array(repeating: nil, count: 9)
    @Published var currentPlayer: Player = .p1
    @Published var gameOver: Bool = false
    
    func makeMove(at index: Int) {
        if !gameOver && squares[index] == nil {
            squares[index] = currentPlayer
            currentPlayer = currentPlayer.opponent
            checkGameResult()
        }
    }
    
    func resetGame() {
        squares = Array(repeating: nil, count: 9)
        currentPlayer = .p1
        gameOver = false
    }
    
    private func checkGameResult() {
        let winningPatterns: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
            [0, 4, 8], [2, 4, 6] // diagonals
        ]
        
        for pattern in winningPatterns {
            let player1 = squares[pattern[0]]
            let player2 = squares[pattern[1]]
            let player3 = squares[pattern[2]]
            
            if player1 != nil && player1 == player2 && player2 == player3 {
                gameOver = true
                return
            }
        }
        
        if !squares.contains(nil) {
            gameOver = true
        }
    }
}
