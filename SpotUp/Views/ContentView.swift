//
//  ContentView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 14.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    @ObservedObject var session = FirebaseAuthentication()
    @State var launchedBefore = false
    @State var permissionRequestedBefore = false
    
    
    var body: some View {
        Group {
            if !self.launchedBefore {
                OnboardingView(launchedBefore: $launchedBefore)
            } else if !self.permissionRequestedBefore {
                PermissionView(permissionRequestedBefore: $permissionRequestedBefore)
            } else if session.currentUser != nil {
                TabBarView().environmentObject(session)
            } else {
                LoginView()
            }
        }
        .onAppear(perform: startUp)
    }
    
    func startUp() {
        self.launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        self.permissionRequestedBefore = UserDefaults.standard.bool(forKey: "permissionRequestedBefore")
        getUser()
        
    }
    
    func getUser() {
        session.listen()
    }
    
    func setLaunchedBefore() {
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
