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

enum BoardResult {
    case ongoing
    case p1win
    case p2win
    case draw
}

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
    
    init(AISelected: Bool) {
        boards = Array(repeating: Board(), count: 9)
        currentPlayer = .p1
        gameResult = .ongoing
        self.AISelected = AISelected
        activeBoardIndex = nil
    }
    
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
        
        if checkBoardWin(boards[boardIndex].squares) {
            boards[boardIndex].result = (currentPlayer == .p1) ? .p1win : .p2win
        } else if checkBoardDraw(boards[boardIndex].squares) {
            boards[boardIndex].result = .draw
        }
        
        if boards[squareIndex].result == .ongoing {
            activeBoardIndex = squareIndex
        } else {
            activeBoardIndex = nil
        }
        
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
            
            if currentPlayer == .p2 && AISelected && gameResult == .ongoing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.makeAIMove()
                }
            }
        }
    }

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
    
    private let winningCombinations = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
        [0, 4, 8], [2, 4, 6] // diagonals
    ]
    
    private func checkBoardWin(_ squares: [Player?]) -> Bool {
        for combination in winningCombinations {
            let s1 = squares[combination[0]]
            let s2 = squares[combination[1]]
            let s3 = squares[combination[2]]
            
            if s1 != nil && s1 == s2 && s1 == s3 {
                return true
            }
        }
        
        return false
    }
    
    private func checkBoardDraw(_ squares: [Player?]) -> Bool {
        for square in squares {
            if square == nil {
                return false
            }
        }
        
        return true
    }
    
    private func checkGameWin(_ boards: [Board]) -> Bool {
        // check horizontal wins
        for i in stride(from: 0, to: 9, by: 3) {
            let row1 = boards[i].result
            let row2 = boards[i + 1].result
            let row3 = boards[i + 2].result
            
            if row1 == .p1win && row2 == .p1win && row3 == .p1win {
                return true
            }
            
            if row1 == .p2win && row2 == .p2win && row3 == .p2win {
                return true
            }
        }
        
        // check vertical wins
        for i in 0..<3 {
            let col1 = boards[i].result
            let col2 = boards[i + 3].result
            let col3 = boards[i + 6].result
            
            if col1 == .p1win && col2 == .p1win && col3 == .p1win {
                return true
            }
            
            if col1 == .p2win && col2 == .p2win && col3 == .p2win {
                return true
            }
        }
        
        // check diagonal wins
        let diagonal1Result = boards[0].result
        let diagonal2Result = boards[2].result
        
        if diagonal1Result == .p1win && boards[4].result == .p1win && diagonal2Result == .p1win {
            return true
        }
        
        if diagonal1Result == .p2win && boards[4].result == .p2win && diagonal2Result == .p2win {
            return true
        }
        
        return false
    }
    
    private func checkGameDraw() -> Bool {
        for board in boards {
            if board.result == .ongoing {
                return false
            }
        }
        
        return true
    }
    
    func resetGame() {
        boards = Array(repeating: Board(), count: 9)
        currentPlayer = .p1
        gameResult = .ongoing
        activeBoardIndex = nil
    }
}
