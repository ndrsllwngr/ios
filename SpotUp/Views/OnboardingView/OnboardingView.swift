//
//  OnboardingView.swift
//  App Onboarding
//
//  Created by Andreas Schultz on 10.08.19.
//  Copyright © 2019 Andreas Schultz. All rights reserved.
//

import SwiftUI

// https://www.blckbirds.com/post/how-to-create-an-onboarding-screen-in-swiftui-2
struct OnboardingView: View {
    
    @Binding var launchedBefore: Bool
    
    var subviews = [
        UIHostingController(rootView: Subview(imageString: "placeholder-onboarding-1")),
        UIHostingController(rootView: Subview(imageString: "placeholder-onboarding-2")),
        UIHostingController(rootView: Subview(imageString: "placeholder-onboarding-3"))
    ]
    
    var titles = ["Avoid Missing Out", "Join the Community", "Explore at Ease"]
    
    var captions =  ["Join SpotUp and experience a better way to share travel tips with your friends.", "Follow your friends’ travels on SpotUp and visit their favourite spots visit their favourite spots or share your own favourite spots.", "SpotUp will guide you to the most nearby places by sorting the spots in your travel list."]
    
    @State var currentPageIndex = 0
    
    var body: some View {
        VStack(spacing: 0){
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                Group {
                    VStack() {
                        Spacer()
                        PageViewController(currentPageIndex: $currentPageIndex, viewControllers: subviews)
                    }
                }
                .padding(.top, 80)
//                .background(Color.blue)
                Group {
                    VStack(spacing: 0) {
                        Text(titles[currentPageIndex]).font(.title).multilineTextAlignment(.center)
                        Text(captions[currentPageIndex]).multilineTextAlignment(.center).padding(.horizontal)
                        Spacer()
                    }.padding(.horizontal)
                }
//                .background(Color.red)
                Spacer()
            }
            HStack {
                PageControl(numberOfPages: subviews.count, currentPageIndex: $currentPageIndex)
                Spacer()
                if(self.currentPageIndex == 2) {
                    Button(action: {
                        UserDefaults.standard.set(true, forKey: "launchedBefore")
                        self.launchedBefore.toggle()
                    }) {
                        VStack (alignment: .trailing) {
                            Text("Finish")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(Color(.white))
                                .padding(.vertical)
                            
                        }
                        .frame(width: 90, height: 40)
                        .background(Color("brand-color-primary"))
                        .mask(Rectangle().cornerRadius(8))
                    }
                } else {
                    Button(action: {
                        if self.currentPageIndex+1 == self.subviews.count {
                            self.currentPageIndex = 0
                        } else {
                            self.currentPageIndex += 1
                        }
                    }) {
                        VStack (alignment: .trailing) {
                            Text("Next")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(Color(.white))
                                .padding(.vertical)
                            
                        }
                        .frame(width: 90, height: 40)
                        .background(Color("brand-color-primary"))
                        .mask(Rectangle().cornerRadius(8))
                    }
                }
            }.padding(.horizontal)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    @State static var launchedBefore: Bool = false
    static var previews: some View {
        OnboardingView(launchedBefore: $launchedBefore)
    }
}


