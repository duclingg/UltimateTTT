//
//  GameSetupView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import SwiftUI

struct GameSetupView: View {
    @State private var AISelected = false
    
    let startColor = Color(red: 0.98, green: 0.58, blue: 0.5)
    let buttonColor = Color("buttonColor")
    let textColor = Color("textColor")
    
    var gameSelection: some View {
        Rectangle()
            .frame(width: 150, height: 60)
            .cornerRadius(10)
            .shadow(radius: 5, x: 3, y: 5)
            .padding()
    }
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Choose Game Mode")
                    .font(.title)
                    .foregroundColor(Color("textColor"))
                    .padding()
                
                Button {
                    AISelected = true
                } label: {
                    gameSelection
                        .foregroundColor(AISelected ? buttonColor : .white)
                        .overlay(
                            Text("CPU")
                                .font(.title2)
                                .padding()
                                .foregroundColor(AISelected ? .white : textColor)
                        )
                }.padding()
                
                Button {
                    AISelected = false
                } label: {
                    gameSelection
                        .foregroundColor(AISelected ? .white : buttonColor)
                        .overlay(
                            Text("Pass and Play")
                                .font(.title2)
                                .padding()
                                .foregroundColor(AISelected ? textColor : .white)
                        )
                }.padding()
                
                NavigationLink(destination: GameView(gameModel: GameModel(AISelected: AISelected), AISelected: AISelected)) {
                    Text("Start Game")
                        .font(.title)
                        .padding()
                        .background(startColor)
                        .foregroundColor(textColor)
                        .cornerRadius(10)
                        .shadow(radius: 5, x: 3, y: 5)
                }
                .padding()
            }
            .padding()
        }
    }
}

struct GameSetupView_Previews: PreviewProvider {
    static var previews: some View {
        GameSetupView()
    }
}
