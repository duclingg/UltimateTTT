//
//  GameModel.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import Foundation

// players
enum Player: String {
    case p1 = "X"
    case p2 = "O"
    
    var opponent: Player {
        return self == .p1 ? .p2 : .p1
    }
}

// board results
enum BoardResult {
    case ongoing
    case p1win
    case p2win
    case draw
}

// board structure
struct Board {
    var squares: [Player?]
    var result: BoardResult
    
    init() {
        squares = Array(repeating: nil, count: 9)
        result = .ongoing
    }
}

class GameModel: ObservableObject {
    @Published var boards: [Board]
    @Published var currentPlayer: Player
    @Published var gameResult: BoardResult = .ongoing
    
    let AISelected: Bool
    var activeBoardIndex: Int?
    
    // method initializes the game options and if AI is selected or not
    init(AISelected: Bool) {
        boards = Array(repeating: Board(), count: 9)
        currentPlayer = .p1
        gameResult = .ongoing
        self.AISelected = AISelected
        activeBoardIndex = nil
    }
    
    // make move function allows players to make a move depending on certain conditions
    func makeMove(boardIndex: Int, squareIndex: Int) {
        guard squareIndex >= 0 && squareIndex < 9 else {
            return
        }
        
        let board = boards[boardIndex]
        
        guard board.squares[squareIndex] == nil else {
            return
        }
        
        if let activeBoardIndex = activeBoardIndex {
            if boards[activeBoardIndex].result != .ongoing && activeBoardIndex != boardIndex {
                return
            }
        }
        
        boards[boardIndex].squares[squareIndex] = currentPlayer
        
        // checks if board is won or tie
        if checkBoardWin(boards[boardIndex].squares) {
            boards[boardIndex].result = (currentPlayer == .p1) ? .p1win : .p2win
        } else if checkBoardDraw(boards[boardIndex].squares) {
            boards[boardIndex].result = .draw
        }
        
        // checks if index is an active board
        if boards[squareIndex].result == .ongoing {
            activeBoardIndex = squareIndex
        } else {
            activeBoardIndex = nil
        }
        
        // check if the game is won else if draw else continue playing
        if checkGameWin(boards) {
            gameResult = (currentPlayer == .p1) ? .p1win : .p2win
        } else if checkGameDraw() {
            gameResult = .draw
        } else {
            switch currentPlayer {
            case .p1:
                currentPlayer = .p2
            case .p2:
                currentPlayer = .p1
            }
            
            if let nextActiveBoardIndex = getValidNextBoardIndex(squareIndex) {
                activeBoardIndex = nextActiveBoardIndex
            } else {
                activeBoardIndex = nil
            }
            
            // if player 2 and AI game mode, play next AI move with time delay
            if currentPlayer == .p2 && AISelected && gameResult == .ongoing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.makeAIMove()
                }
            }
        }
    }

    // makes AI move
    private func makeAIMove() {
        guard let activeBoardIndex = activeBoardIndex else {
            return
        }
        
        var emptySquares: [Int] = []
        
        for squareIndex in 0..<9 {
            if boards[activeBoardIndex].squares[squareIndex] == nil {
                emptySquares.append(squareIndex)
            }
        }
        
        if emptySquares.isEmpty {
            return
        }
        
        let randomIndex = Int.random(in: 0..<emptySquares.count)
        let selectedSquareIndex = emptySquares[randomIndex]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.makeMove(boardIndex: activeBoardIndex, squareIndex: selectedSquareIndex)
        }
    }
    
    // gets the next valid board index
    private func getValidNextBoardIndex(_ squareIndex: Int) -> Int? {
        if let activeBoardIndex = activeBoardIndex, boards[activeBoardIndex].result == .ongoing {
            return activeBoardIndex
        }
        
        for boardIndex in 0..<boards.count {
            if boards[boardIndex].result == .ongoing && boardIndex != squareIndex {
                return boardIndex
            }
        }
        
        return squareIndex
    }
    
    // check if board is a win
    private func checkBoardWin(_ squares: [Player?]) -> Bool {
        let boardWinCombos = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
            [0, 4, 8], [2, 4, 6] // diagonals
        ]
        
        for pattern in boardWinCombos {
            let s1 = squares[pattern[0]]
            let s2 = squares[pattern[1]]
            let s3 = squares[pattern[2]]
            
            if s1 != nil && s1 == s2 && s1 == s3 {
                return true
            }
        }
        
        return false
    }
    
    // check if board is a draw
    private func checkBoardDraw(_ squares: [Player?]) -> Bool {
        return squares.allSatisfy { $0 != nil }
    }
    
    // checks if the entire there is a game winner
    private func checkGameWin(_ boards: [Board]) -> Bool {
        let gameWinCombos: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
            [0, 4, 8], [2, 4, 6] // diagonals
        ]
        
        for pattern in gameWinCombos {
            let b1 = boards[pattern[0]].result
            let b2 = boards[pattern[1]].result
            let b3 = boards[pattern[2]].result
            
            if b1 == .p1win && b2 == .p1win && b3 == .p1win {
                return true
            }
            
            if b1 == .p2win && b2 == .p2win && b3 == .p2win {
                return true
            }
        }
        
        return false
    }
    
    // check if there is a draw in the game
    private func checkGameDraw() -> Bool {
        return !boards.contains { $0.result == .ongoing }
    }
    
    // resets the game, new game
    func resetGame() {
        boards = Array(repeating: Board(), count: 9)
        currentPlayer = .p1
        gameResult = .ongoing
        activeBoardIndex = nil
    }
}
