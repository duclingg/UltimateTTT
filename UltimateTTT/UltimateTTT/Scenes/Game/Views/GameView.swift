//
//  GameView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameModel: GameModel
    
    let AISelected: Bool
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                BoardGridView(gameModel: gameModel)
                
                Button {
                    gameModel.resetGame()
                } label: {
                    Text("reset game")
                        .font(.title)
                        .padding()
                        .foregroundColor(Color("textColor"))
                        .background(Color("buttonColor"))
                        .cornerRadius(10)
                }
                .padding()
                
                switch gameModel.gameResult {
                case .p1win:
                    Text("Player 1 Wins!")
                        .font(.title)
                        .foregroundColor(Color("textColor"))
                        .padding()
                case .p2win:
                    Text("Player 2 Wins!")
                        .font(.title)
                        .foregroundColor(Color("textColor"))
                        .padding()
                case .draw:
                    Text("It's a Draw!")
                        .font(.title)
                        .foregroundColor(Color("textColor"))
                        .padding()
                case .ongoing:
                    EmptyView()
                }
            }
            .padding()
        }
    }
}

struct BoardView: View {
    @ObservedObject var gameModel: GameModel
    
    let boardIndex: Int
    
    var body: some View {
        let board = gameModel.boards[boardIndex]
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 3), spacing: 5) {
            ForEach(0..<9) { squareIndex in
                Button {
                    gameModel.makeMove(boardIndex: boardIndex, squareIndex: squareIndex)
                } label: {
                    Text(board.squares[squareIndex]?.rawValue ?? "")
                        .font(.system(size: 24))
                        .frame(width: 40, height: 40)
                        .background(Color("butttonColor"))
                        .foregroundColor(Color("textColor"))
                        .cornerRadius(5)
                }
                .disabled(boardDisabled(squareIndex))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 2)
                )
            }
        }
    }
    
    private func boardDisabled(_ squareIndex: Int) -> Bool {
        guard let activeBoardIndex = gameModel.activeBoardIndex else {
            return false
        }
        
        let board = gameModel.boards[activeBoardIndex]
        
        if board.result != .ongoing || gameModel.gameResult != .ongoing {
            return true
        }
        
        if activeBoardIndex != boardIndex {
            return true
        }
        
        if board.result == .p1win || board.result == .p2win || board.result == .draw {
            
            return false
        }
        
        return boardIndex != gameModel.activeBoardIndex && gameModel.activeBoardIndex != nil
    }
}

struct BoardGridView: View {
    @ObservedObject var gameModel: GameModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 3), spacing: 5) {
            ForEach(0..<9) { boardIndex in
                BoardView(gameModel: gameModel, boardIndex: boardIndex)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameModel: GameModel(AISelected: false), AISelected: false)
    }
}
