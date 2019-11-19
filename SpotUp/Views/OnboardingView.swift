//
//  OnboardingView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        
        NavigationView {
            NavigationLink(destination: ContentView()) {
                Text("Skip")
            }
            .simultaneousGesture(TapGesture().onEnded {
                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                }
            )
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
