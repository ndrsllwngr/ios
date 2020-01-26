//
//  PermissionsView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import CoreLocation

struct PermissionView: View {
    
    @Binding var permissionRequestedBefore: Bool
    @State var locationManager: LocationManager?
    
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    Spacer()
                }
                Spacer()
            }
            .frame(minHeight: 0, maxHeight: .infinity)
            .background(Color("brand-color-primary"))
            .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Spacer()
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Spacer()
                        Image(uiImage: UIImage(named: "explore-empty-target-bw")!)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .center)
                        Text("Don't overthink").font(.title).fontWeight(.bold).foregroundColor(Color.white).multilineTextAlignment(.center).padding(.horizontal)
                        Text("Get guided to all your favourite spots\n near your location.").font(.body).foregroundColor(Color.white).multilineTextAlignment(.center).padding(.horizontal)
                        Group {
                            Button(action: {
                                self.locationManager = LocationManager()
                                self.locationManager?.requestAuth()
                            }){
                                Text("Grant location access")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("brand-color-primary"))
                            }
                            .padding(.horizontal)
                            .frame(height: 42)
                            .background(Color.white)
                            .mask(Rectangle().cornerRadius(8))
                        }.padding(.top, 40)
                        Spacer()
                    }
                    .padding(.vertical)
                    Spacer()
                }
                Spacer()
            }
            VStack(alignment: .trailing){
                HStack {
                    Spacer()
                    Button (action: {
                        UserDefaults.standard.set(true, forKey: "permissionRequestedBefore")
                        self.permissionRequestedBefore.toggle()
                    }){
                        VStack (alignment: .trailing) {
                            Text("Continue")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .frame(height: 38)
                                .padding(.horizontal)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 2))
                        }
                    }
                }
                .padding()
                Spacer()
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
