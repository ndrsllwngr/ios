//
//  ItemContentView.swift
//  SpotUp
//
//  Created by Havy Ha on 02.12.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct ItemContentView: View {
    var body: some View {
        VStack {
            ItemMapView()
                .edgesIgnoringSafeArea(.top)
                .frame(height:400)
            
            ItemImageView()
                .frame(width:150,height:150)
                .offset(y:-90)
                .padding(.bottom,-90)
            
            
            VStack(alignment: .leading) {
                        Text("Turtle Rock")
                            .font(.title)
                        HStack {
                            Text("Joshua Tree National Park")
                                .font(.subheadline)
                            Spacer()
                            Text("California")
                                .font(.subheadline)
                        }
            }
            .padding(.all)
                    Spacer()
                }
            }
        }
        
        

struct ItemContentView_Previews: PreviewProvider {
    static var previews: some View {
        ItemContentView()
    }
}
