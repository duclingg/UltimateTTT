//
//  GameView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameModel = GameModel()
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], spacing: 10) {
                ForEach(0..<9) { index in
                    Button {
                        gameModel.makeMove(at: index)
                    } label: {
                        Text(gameModel.squares[index]?.rawValue ?? "")
                            .font(.system(size: 80))
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color("textColor"))
                            .background(Color("buttonColor"))
                            .cornerRadius(10)
                    }
                    .disabled(gameModel.squares[index] != nil || gameModel.gameOver)
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
            
            if gameModel.gameOver {
                Text("Game Over!")
                    .font(.title)
                    .foregroundColor(Color("textColor"))
                    .padding()
            }
        }
        .padding()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
