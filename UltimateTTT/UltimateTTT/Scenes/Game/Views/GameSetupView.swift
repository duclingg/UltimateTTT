//
//  GameSetupView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import SwiftUI

struct GameSetupView: View {
    @State private var AISelected = false
    
    let startColor = Color(red: 0.96, green: 0.18, blue: 0.18)
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Choose Opponent")
                    .font(.title)
                    .foregroundColor(Color("textColor"))
                    .padding()
                
                Button {
                    AISelected = true
                } label: {
                    Text("CPU")
                        .font(.title2)
                        .padding()
                        .foregroundColor(AISelected ? .white : Color("textColor"))
                        .background(AISelected ? Color("buttonColor") : .white)
                        .cornerRadius(10)
                }.padding()
                
                Button {
                    AISelected = false
                } label: {
                    Text("Pass and Play")
                        .font(.title2)
                        .padding()
                        .foregroundColor(AISelected ? Color("textColor") : .white)
                        .background(AISelected ? .white : Color("buttonColor"))
                        .cornerRadius(10)
                }.padding()
                
                NavigationLink(destination: GameView(AISelected: AISelected)) {
                    Text("Start Game")
                        .font(.title)
                        .padding()
                        .background(startColor)
                        .foregroundColor(Color("textColor"))
                        .cornerRadius(10)
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
