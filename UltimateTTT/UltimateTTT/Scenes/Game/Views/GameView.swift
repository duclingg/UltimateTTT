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
    @State private var resetConfirmation = false
    
    let AISelected: Bool
    
    let p1Color = Color("p1Color")
    let p2Color = Color("p2Color")
    let menuColor = Color("menuColor").opacity(0.9)
    let onColor = Color("onColor")
    let offColor = Color("offColor")
    let okColor = Color("okColor")
    
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
                HStack {
                    // inidicates player turn
                    p1Turn
                    p2Turn
                }
                Spacer()
            }
            
            ZStack {
                // display the game board
                BoardGridView(gameModel: gameModel)
                    .padding()
                
                // anounce p1 game winner
                if gameModel.gameResult == .p1win {
                    p1Winner
                }
                
                // announce p2 game winner
                if gameModel.gameResult == .p2win {
                    p2Winner
                }
                
                // announce game draw
                if gameModel.gameResult == .draw {
                    drawGame
                }
                
                // display exit confirmation pop up
                if exitConfirmation == true {
                    exitGame
                }
                
                // display reset game confirmation pop up
                if resetConfirmation == true {
                    resetGame
                }
            }
            
            VStack() {
                // paused menu selected
                if isPaused && !exitConfirmation && !resetConfirmation {
                    gamePaused
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var gamePaused: some View {
        ZStack {
            buttonLayout
                .frame(width: 200, height: 350)
                .foregroundColor(menuColor)
            
            VStack {
                Text("Game Paused")
                    .font(.title2).fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .shadow(radius: 2)
                
                Button {
                    isPaused = false
                } label: {
                    ZStack {
                        buttonLayout
                            .frame(width: 150, height: 60)
                            .foregroundColor(onColor)
                        
                        Text("Resume")
                            .font(.title2).fontWeight(.semibold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }
                
                Button {
                    resetConfirmation = true
                } label: {
                    ZStack {
                        buttonLayout
                            .frame(width: 150, height: 60)
                            .foregroundColor(okColor)
                        
                        Text("Restart Game")
                            .font(.title2).fontWeight(.semibold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }
                
                Button {
                    exitConfirmation = true
                } label: {
                    ZStack {
                        buttonLayout
                            .frame(width: 150, height: 60)
                            .foregroundColor(offColor)
                        
                        Text("Exit Game")
                            .font(.title2).fontWeight(.semibold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }
            }
        }
    }
    
    // reset game confirmation pop up
    private var resetGame: some View {
        ZStack {
            buttonLayout
                .frame(width: 300, height: 200)
                .foregroundColor(menuColor)
            
            VStack {
                Text("Are you sure you want \nto restart the game?")
                    .font(.title2).fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .padding(.bottom, 20)
                
                HStack {
                    Button {
                        gameModel.resetGame()
                        resetConfirmation = false
                        isPaused = false
                    } label: {
                        ZStack {
                            buttonLayout
                                .frame(width: 100, height: 40)
                                .foregroundColor(onColor)
                            
                            Text("YES")
                                .font(.title2).fontWeight(.semibold)
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                        }
                    }.padding()
                    
                    Button {
                        resetConfirmation = false
                    } label: {
                        ZStack {
                            buttonLayout
                                .frame(width: 100, height: 40)
                                .foregroundColor(offColor)
                            
                            Text("NO")
                                .font(.title2).fontWeight(.semibold)
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                        }
                    }.padding()
                }
            }
        }
    }
    
    // exit game confirmation pop up
    private var exitGame: some View {
        ZStack {
            buttonLayout
                .frame(width: 300, height: 200)
                .foregroundColor(menuColor)
            
            VStack {
                Text("Are you sure you want \nto exit the game?")
                    .font(.title2).fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .padding(.bottom, 20)
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        gameModel.resetGame()
                    } label: {
                        ZStack {
                            buttonLayout
                                .frame(width: 100, height: 40)
                                .foregroundColor(onColor)
                            
                            Text("YES")
                                .font(.title2).fontWeight(.semibold)
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                        }
                    }.padding()
                    
                    Button {
                        exitConfirmation = false
                    } label: {
                        ZStack {
                            buttonLayout
                                .frame(width: 100, height: 40)
                                .foregroundColor(offColor)
                            
                            Text("NO")
                                .font(.title2).fontWeight(.semibold)
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                        }
                    }.padding()
                }
            }
        }
    }
    
    private var p1Turn: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 70, height: 70)
                .foregroundColor(gameModel.currentPlayer == .p1 ? p1Color : .white)
                .shadow(radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(gameModel.currentPlayer == .p1 ? .white : p1Color, lineWidth: 1)
                )
            
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(gameModel.currentPlayer == .p1 ? .white : p1Color)
        }.padding(30)
    }
    
    private var p2Turn: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 70, height: 70)
                .foregroundColor(gameModel.currentPlayer == .p2 ? p2Color : .white)
                .shadow(radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(gameModel.currentPlayer == .p2 ? .white : p2Color, lineWidth: 1)
            )
            
            Image(systemName: "circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(gameModel.currentPlayer == .p2 ? .white : p2Color)
        }.padding(30)
    }
    
    private var p1Winner: some View {
        ZStack {
            buttonLayout
                .frame(width: 200, height: 250)
                .foregroundColor(p1Color).opacity(0.9)
            
            VStack {
                Text("Player 1 Wins!")
                    .font(.title2).fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .padding(.bottom, 20)
                
                Button {
                    gameModel.resetGame()
                } label: {
                    ZStack {
                        buttonLayout
                            .frame(width: 100, height: 40)
                            .foregroundColor(onColor)
                        
                        Text("Play Again")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }
                
                Button {
                    exitConfirmation = true
                } label: {
                    ZStack {
                        buttonLayout
                            .frame(width: 100, height: 40)
                            .foregroundColor(okColor)
                        
                        Text("Exit Game")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }.padding()
            }
        }
    }
    
    private var p2Winner: some View {
        ZStack {
            buttonLayout
                .frame(width: 200, height: 250)
                .foregroundColor(p2Color).opacity(0.9)
            
            VStack {
                Text("Player 2 Wins!")
                    .font(.title2).fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .padding(.bottom, 20)
                
                Button {
                    gameModel.resetGame()
                } label: {
                    ZStack {
                        buttonLayout
                            .frame(width: 100, height: 40)
                            .foregroundColor(onColor)
                        
                        Text("Play Again")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }
                
                Button {
                    exitConfirmation = true
                } label: {
                    ZStack {
                        buttonLayout
                            .frame(width: 100, height: 40)
                            .foregroundColor(okColor)
                        
                        Text("Exit Game")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }.padding()
            }
        }
    }
    
    private var drawGame: some View {
        ZStack {
            buttonLayout
                .frame(width: 200, height: 225)
                .foregroundColor(menuColor)
            
            VStack {
                Text("DRAW!")
                    .font(.title2).fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .padding()
                
                Button {
                    gameModel.resetGame()
                } label: {
                    ZStack {
                        buttonLayout
                            .frame(width: 100, height: 40)
                            .foregroundColor(onColor)
                        
                        Text("Play Again")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }
                
                Button {
                    exitConfirmation = true
                } label: {
                    ZStack {
                        buttonLayout
                            .frame(width: 100, height: 40)
                            .foregroundColor(okColor)
                        
                        Text("Exit Game")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }.padding()
            }
        }
    }
    
    private var buttonLayout: some View {
        RoundedRectangle(cornerRadius: 10)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white, lineWidth: 1)
            )
    }
}

struct BoardView: View {
    @ObservedObject var gameModel: GameModel
    @State private var isActive = false
    
    let boardIndex: Int
    
    let p1Color = Color("p1Color")
    let p2Color = Color("p2Color")
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
