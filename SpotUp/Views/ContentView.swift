//
//  ContentView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 14.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    @ObservedObject var session = FirebaseSession()
    var body: some View {
            Group {
                if !UserDefaults.standard.bool(forKey: "launchedBefore") {
                    OnboardingView()
                } else if !UserDefaults.standard.bool(forKey: "permissionNotificationSet") {
                    PermissionView()
                } else if session.session != nil {
                    TabBarView()
                } else {
                    LoginView()
                }
            }
            .onAppear(perform: getUser)   
    }

    func getUser() {
        session.listen()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
