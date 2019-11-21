//
//  PermissionsView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct PermissionView: View {
    
    @Binding var permissionRequestedBefore: Bool
    
    var body: some View {
        VStack {
            Text("PermissionView")
            Text("To function throughoutly SpotUp needs some permissions")
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: {
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                    // Enable or disable features based on authorization.
                }
            }){
                Text("Request Permission")
            }
            Spacer()
            Button (action: {
                UserDefaults.standard.set(true, forKey: "permissionRequestedBefore")
                self.permissionRequestedBefore.toggle()
            }){
                Text("Finish")
            }
        }
    }
}

struct PermissionView_Previews: PreviewProvider {
    @State static var permissionRequestedBefore = false
    static var previews: some View {
        PermissionView(permissionRequestedBefore: $permissionRequestedBefore)
    }
}
