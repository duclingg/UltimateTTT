//
//  HomeView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import SwiftUI

struct HomeView: View {
    var menuButtons: some View {
        Rectangle()
            .frame(width: 140, height: 60)
            .foregroundColor(.gray)
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
                VStack {
                    Text("Ultimate Tic Tac Toe")
                        .font(.title).fontWeight(.bold)
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
                                        .foregroundColor(.white)
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
