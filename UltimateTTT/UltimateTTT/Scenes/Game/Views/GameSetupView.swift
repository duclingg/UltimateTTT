//
//  GameSetupView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import SwiftUI

struct GameSetupView: View {
    @State private var AISelected = false
    
    var body: some View {
        VStack {
            Text("Choose Opponent")
                .font(.title)
                .padding()
            
            Toggle("Play aginst AI", isOn: $AISelected)
                .font(.title2)
                .padding()
            
            NavigationLink(destination: GameView(AISelected: AISelected)) {
                Text("Start Game")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color("textColor"))
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

struct GameSetupView_Previews: PreviewProvider {
    static var previews: some View {
        GameSetupView()
    }
}
