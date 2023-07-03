//
//  HomeView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import SwiftUI

struct HomeView: View {
    let backgroundColor = Color("backgroundColor")
    let buttonColor = Color("buttonColor")
    let textColor = Color("textColor")
        
    var menuButtons: some View {
        Rectangle()
            .frame(width: 150, height: 60)
            .foregroundColor(buttonColor)
            .cornerRadius(10)
            .shadow(radius: 5, x: 3, y: 5)
            .padding()
    }
    
    let menuLabels = [
        Item(name: "Play"),
        Item(name: "Leaderboard"),
        Item(name: "Tutorial"),
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
                        .shadow(radius: 5, x: 3, y: 5)
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
                GameSetupView()
            }
            
            if item.name == "Leaderboard" {
                LeaderboardView()
            }
            
            if item.name == "Tutorial" {
                TutorialView()
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
            Image(systemName: "chevron.backward")
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
