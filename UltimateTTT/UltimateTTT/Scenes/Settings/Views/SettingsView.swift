//
//  SettingsView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 6/25/23.
//

import SwiftUI

struct SettingsView: View {
    // all options on by default
    @State private var soundOn = true
    @State private var vibrationOn = true
    @State private var notificationsOn = true
    
    let backgroundColor = Color("backgroundColor")
    let buttonColor = Color("buttonColor")
    
    var body: some View {
        ZStack {
            List {
                Toggle("Sound", isOn: $soundOn)
                    .toggleStyle(SwitchToggleStyle(tint: .gray))
                Toggle("Vibrations", isOn: $vibrationOn)
                    .toggleStyle(SwitchToggleStyle(tint: .gray))
                Toggle("Notifications", isOn: $notificationsOn)
                    .toggleStyle(SwitchToggleStyle(tint: .gray))
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
