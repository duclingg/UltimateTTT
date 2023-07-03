//
//  HomeView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import SwiftUI

struct HomeView: View {
    let backgroundColor = Color("backgroundColor")
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Ultimate")
                        .font(.title).fontWeight(.semibold)
                    Text("Tic Tac Toe")
                        .font(.title).fontWeight(.semibold)
                    Spacer()
                }
                .padding()
                
                VStack {
                    Spacer()
                    NavigationLink(destination: GameSetupView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 200, height: 80)
                                .foregroundColor(Color(red: 0.98, green: 0.79, blue: 0.4))
                                .shadow(radius: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.white, lineWidth: 1)
                            )
                            Text("START")
                                .font(.largeTitle).fontWeight(.semibold)
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                        }
                    }
                }
                .padding(.bottom, 100)
            }
        }
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
