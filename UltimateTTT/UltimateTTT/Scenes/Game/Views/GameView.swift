//
//  GameView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameModel = GameModel()
    
    let AISelected: Bool
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], spacing: 10) {
                    ForEach(0..<9) { index in
                        Button {
                            gameModel.makeMove(at: index)
                            if AISelected && gameModel.currentPlayer == .p2 && gameModel.gameResult == .ongoing {
                                gameModel.makeAIMove()
                            }
                        } label: {
                            Text(gameModel.squares[index]?.rawValue ?? "")
                                .font(.system(size: 80))
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color("textColor"))
                                .overlay(
                                    Rectangle()
                                        .stroke(Color("buttonColor"), lineWidth: 3)
                                )
                        }
                        .disabled(gameModel.squares[index] != nil || gameModel.gameResult != .ongoing || (AISelected && gameModel.currentPlayer == .p2))
                    }
                }
                
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

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameModel: GameModel(), AISelected: false)
    }
}
