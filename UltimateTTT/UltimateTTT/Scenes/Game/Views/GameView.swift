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
                
                // start new game
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
                
                // announce game winner or tie
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
    
    let p1Color = Color(red: 0.97, green: 0.43, blue: 0.38)
    let p2Color = Color(red: 0.43, green: 0.57, blue: 0.93)
    let unactiveColor = Color.gray.opacity(0.25)
    
    var body: some View {
        let board = gameModel.boards[boardIndex]
        
        ZStack {
            // creates squares for each board
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 0.5) {
                ForEach(0..<9) { squareIndex in
                    let player = board.squares[squareIndex]
                    let mark = player?.rawValue ?? ""
                    let markColor = (player == .p1) ? p1Color : p2Color
                    
                    // mark the square index with player's icon
                    Button {
                        gameModel.makeMove(boardIndex: boardIndex, squareIndex: squareIndex)
                    } label: {
                        Text(mark)
                            .font(.system(size: 24))
                            .frame(width: 40, height: 40)
                            .foregroundColor(markColor)
                            .background(Color("backgroundColor"))
                    }
                    .disabled(boardDisabled(squareIndex))
                }
            }
            .background(Color.black)

            
            // if board win mark board with player's icon
            switch board.result {
            case .p1win:
                p1BoardWin
            case .p2win:
                p2BoardWin
            case .draw:
                drawBoard
            default:
                Color.clear
            }
        }
    }
    
    private var p1BoardWin: some View {
        unactiveColor
            .aspectRatio(contentMode: .fit)
            .cornerRadius(5)
            .overlay(
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .foregroundColor(p1Color)
            )
    }
    
    private var p2BoardWin: some View {
        unactiveColor
            .aspectRatio(contentMode: .fit)
            .cornerRadius(5)
            .overlay(
                Image(systemName: "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .foregroundColor(p2Color)
            )
    }
    
    private var drawBoard: some View {
        unactiveColor
            .aspectRatio(contentMode: .fit)
            .cornerRadius(5)
    }
    
    // disable the board on condition
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
        
        return false
    }
}

// creates the entire game board
struct BoardGridView: View {
    @ObservedObject var gameModel: GameModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 11), count: 3), spacing: 5) {
            ForEach(0..<9) { boardIndex in
                BoardView(gameModel: gameModel, boardIndex: boardIndex)
            }
        }
        .background(Color.black)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameModel: GameModel(AISelected: false), AISelected: false)
    }
}
