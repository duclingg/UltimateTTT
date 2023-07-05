//
//  GameSetupView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import SwiftUI

struct GameSetupView: View {
    @State private var AISelected = true
    @State private var vibrationSelected = true
    @State private var soundSelected = true
    
    let onColor = Color("onColor")
    let offColor = Color("offColor")
    let okColor = Color("okColor")
    
    var gameSelection: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 200, height: 80)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white, lineWidth: 1)
            )
            .padding()
    }
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Select Game Mode")
                    .font(.title).fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding()
                
                // Human vs CPU game mode: on by default
                Button {
                    AISelected = true
                } label: {
                    gameSelection
                        .foregroundColor(AISelected ? onColor : offColor)
                        .overlay(
                            Text("CPU")
                                .font(.title).fontWeight(.semibold)
                                .shadow(radius: 2)
                                .padding()
                                .foregroundColor(.white)
                        )
                }
                
                // Human vs Human game mode
                Button {
                    AISelected = false
                } label: {
                    gameSelection
                        .foregroundColor(AISelected ? offColor : onColor)
                        .overlay(
                            Text("Pass and Play")
                                .font(.title).fontWeight(.semibold)
                                .shadow(radius: 2)
                                .padding()
                                .foregroundColor(.white)
                        )
                }
                
                Text("Settings")
                    .font(.title).fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding()
                
                HStack {
                    // vibration enabled
                    Button {
                        vibrationSelected.toggle()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 140, height: 50)
                                .foregroundColor(vibrationSelected ? onColor : offColor)
                                .shadow(radius: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.white, lineWidth: 1)
                                )
                                .padding()
                            Text("Vibration")
                                .font(.title).fontWeight(.semibold)
                                .shadow(radius: 2)
                                .foregroundColor(.white)
                        }
                    }
                    
                    // sound enabled
                    Button {
                        soundSelected.toggle()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 140, height: 50)
                                .foregroundColor(soundSelected ? onColor : offColor)
                                .shadow(radius: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.white, lineWidth: 1)
                                )
                                .padding()
                            Text("Sounds")
                                .font(.title).fontWeight(.semibold)
                                .shadow(radius: 2)
                                .foregroundColor(.white)
                        }
                    }
                    
                    
                }.padding()
                
                Spacer()
                
                // start the game with selected options
                NavigationLink(destination: GameView(gameModel: GameModel(AISelected: AISelected), AISelected: AISelected)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 200, height: 80)
                            .foregroundColor(okColor)
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.white, lineWidth: 1)
                            )
                        Text("PLAY")
                            .font(.largeTitle).fontWeight(.semibold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }
                .padding()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct GameSetupView_Previews: PreviewProvider {
    static var previews: some View {
        GameSetupView()
    }
}
