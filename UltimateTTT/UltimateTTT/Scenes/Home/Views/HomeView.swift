//
//  HomeView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import SwiftUI

struct HomeView: View {
    let backgroundColor = Color(red: 0.89, green: 0.98, blue: 0.84)
    let buttonColor = Color(red: 0.8, green: 0.82, blue: 0.86)
    let textColor = Color(red: 0.44, green: 0.44, blue: 0.48)
        
    var menuButtons: some View {
        Rectangle()
            .frame(width: 150, height: 60)
            .foregroundColor(buttonColor)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()
    }
    
    let menuLabels = [
        Item(name: "Play"),
        Item(name: "Leaderboard"),
        Item(name: "Tutorial"),
        Item(name: "Settings")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Ultimate Tic Tac Toe")
                        .font(.title).fontWeight(.bold)
                        .foregroundColor(textColor)
                        .padding()
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    ForEach(menuLabels) { item in
                        NavigationLink(destination: MenuViews(item: item)) {
                            menuButtons
                                .overlay(
                                    Text(item.name)
                                        .font(.title2).fontWeight(.semibold)
                                        .foregroundColor(textColor)
                                )
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct Item: Identifiable {
    let id = UUID()
    let name: String
}

struct MenuViews: View {
    let item: Item
    
    var body: some View {
        ZStack {
            if item.name == "Play" {
                GameView()
            }
            
            if item.name == "Leaderboard" {
                LeaderboardView()
            }
            
            if item.name == "Tutorial" {
                TutorialView()
            }
            
            if item.name == "Settings" {
                SettingsView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .font(.title3).fontWeight(.bold)
                .foregroundColor(.black)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
