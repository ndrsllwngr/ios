//
//  SettingsView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("SettingsView")
            Spacer()
            Button(action: {
                FirebaseAuthentication().logOut()
            }) {
                Text("Log Out").foregroundColor(.red)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
