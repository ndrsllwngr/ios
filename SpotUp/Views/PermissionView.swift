//
//  PermissionsView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct PermissionView: View {
    var body: some View {
        VStack {
            Button(action: {
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                    // Enable or disable features based on authorization.
                }          
            }) {
                Text("Request Permission")
            }
            NavigationView {
                NavigationLink(destination: ContentView()) {
                    Text("Finish")
                }
                .simultaneousGesture(TapGesture().onEnded {
                        UserDefaults.standard.set(true, forKey: "permissionNotificationSet")
                    }
                )
            }
        }
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView()
    }
}
