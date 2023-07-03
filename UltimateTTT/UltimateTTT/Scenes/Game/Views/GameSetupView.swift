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
    
    let startColor = Color(red: 0.98, green: 0.79, blue: 0.4)
    let buttonColor = Color("buttonColor")
    let textColor = Color("textColor")
    let onColor = Color("onColor")
    let offColor = Color("offColor")
    
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
                    .padding()
                
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
                    .padding()
                
                HStack {
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
                
                NavigationLink(destination: GameView(gameModel: GameModel(AISelected: AISelected), AISelected: AISelected)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 200, height: 80)
                            .foregroundColor(startColor)
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
