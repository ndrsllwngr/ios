//
//  SplashScreen.swift
//  SpotUp
//
//  Created by Timo Erdelt on 25.01.20.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(uiImage: UIImage(named: "logo-icon")!)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                Spacer()
            }
            Spacer()
        }
        .frame(minHeight: 0, maxHeight: .infinity)
        .background(Color("brand-color-primary"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
