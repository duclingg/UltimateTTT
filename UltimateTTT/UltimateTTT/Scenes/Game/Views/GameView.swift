//
//  GameView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import SwiftUI

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameModel: GameModel
    @State private var isPaused = false
    @State private var exitConfirmation = false
    
    let AISelected: Bool
    let textColor = Color("textColor")
    let winColor = Color(red: 1, green: 0.81, blue: 0.65)
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    // show pause button if not paused already
                    if !isPaused {
                        // pause button
                        Button {
                            isPaused = true
                        } label: {
                            Image(systemName: "pause.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .font(.title)
                                .foregroundColor(Color.black)
                        }.padding()
                    } else {
                        EmptyView()
                    }
                    Spacer()
                }
                Spacer()
            }
            
            VStack {
                // announce game winner or tie
                switch gameModel.gameResult {
                case .p1win:
                    Text("Player 1 Wins!")
                        .padding(.all, 5)
                        .font(.title)
                        .foregroundColor(textColor)
                        .background(winColor)
                        .cornerRadius(10)
                        .padding()
                case .p2win:
                    Text("Player 2 Wins!")
                        .padding(.all, 5)
                        .font(.title)
                        .foregroundColor(textColor)
                        .background(winColor)
                        .cornerRadius(10)
                        .padding()
                case .draw:
                    Text("It's a Draw!")
                        .padding(.all, 5)
                        .font(.title)
                        .foregroundColor(textColor)
                        .background(winColor)
                        .cornerRadius(10)
                        .padding()
                case .ongoing:
                    EmptyView()
                }
                
                // announce whose turn it is
                if gameModel.gameResult == .ongoing {
                    switch gameModel.currentPlayer {
                    case .p1:
                        Text("Player 1 Turn")
                            .font(.title)
                            .foregroundColor(Color(red: 0.97, green: 0.43, blue: 0.38))
                            .padding()
                    case .p2:
                        if gameModel.currentPlayer == .p2 && AISelected {
                            Text("CPU Turn")
                                .font(.title)
                                .foregroundColor(Color(red: 0.43, green: 0.57, blue: 0.93))
                                .padding()
                        } else {
                            Text("Player 2 Turn")
                                .font(.title)
                                .foregroundColor(Color(red: 0.43, green: 0.57, blue: 0.93))
                                .padding()
                        }
                    }
                }
                
                BoardGridView(gameModel: gameModel)
            }
            .padding()
            
            VStack() {
                // paused menu selected
                if isPaused {
                    Color.white.opacity(0.9)
                        .frame(width: 250, height: 400)
                        .cornerRadius(10)
                        .overlay(
                            VStack {
                                Text("Game Paused")
                                    .font(.title)
                                    .foregroundColor(textColor)
                                
                                // resume game
                                Button {
                                    isPaused = false
                                } label: {
                                    Text("Resume")
                                        .padding()
                                        .font(.title)
                                        .foregroundColor(textColor)
                                        .background(Color("buttonColor"))
                                        .cornerRadius(10)
                                }.padding()
                                
                                // start new game
                                Button {
                                    gameModel.resetGame()
                                    isPaused = false
                                } label: {
                                    Text("Reset Game")
                                        .padding()
                                        .font(.title)
                                        .foregroundColor(textColor)
                                        .background(Color("buttonColor"))
                                        .cornerRadius(10)
                                }.padding()
                                
                                // exit game
                                Button {
                                    exitConfirmation = true
                                } label: {
                                    Text("Exit Game")
                                        .padding()
                                        .font(.title)
                                        .foregroundColor(textColor)
                                        .background(Color("buttonColor"))
                                        .cornerRadius(10)
                                }.padding()
                            }
                        )
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $exitConfirmation) {
            Alert(
                title: Text("Exit Game"),
                message: Text("Are you sure you want to exit to the main menu?"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Exit")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct BoardView: View {
    @ObservedObject var gameModel: GameModel
    @State private var isActive = false
    
    let boardIndex: Int
    
    let p1Color = Color(red: 0.97, green: 0.43, blue: 0.38)
    let p2Color = Color(red: 0.43, green: 0.57, blue: 0.93)
    let unactiveColor = Color.gray.opacity(0.25)
    let activeColor = Color(red: 1, green: 0.95, blue: 0.84).opacity(0.5)
    
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
                    .disabled(boardDisabled(boardIndex))
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
                EmptyView()
            }
            
            // highlights the current active/playable board
            if gameModel.activeBoardIndex == boardIndex {
                activeBoard
            }
        }
    }
    
    // p1 board win: mark with "X"
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
    
    // p2 board win: mark with "O"
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
    
    // board draw: gray out
    private var drawBoard: some View {
        unactiveColor
            .aspectRatio(contentMode: .fit)
            .cornerRadius(5)
    }
    
    // highlight current active board
    private var activeBoard: some View {
        activeColor
            .aspectRatio(contentMode: .fit)
            .cornerRadius(5)
            .allowsHitTesting(false)
    }
    
    // disable the board on condition
    private func boardDisabled(_ boardIndex: Int) -> Bool {
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
