//
//  OnboardingView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var launchedBefore: Bool
    
    var body: some View {
        VStack {
            Text("OnboardingView")
            Text("Here you will find Information about the app on first start")
                .multilineTextAlignment(.center)
            Spacer()
            Button (action: {
                UserDefaults.standard.set(true, forKey: "launchedBefore")
                self.launchedBefore.toggle()
            }){
                Text("Skip")
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    @State static var launchedBefore = false
    static var previews: some View {
        OnboardingView(launchedBefore: $launchedBefore)
    }
}
