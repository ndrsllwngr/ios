import SwiftUI

struct TabBarView: View {
    // LOCAL
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject var exploreModel = ExploreModel.shared
    @State var selection = 2
    
    var body: some View {
        GeometryReader { metrics in
            ZStack{
                VStack(spacing: 0) {
                    HStack(spacing: 0){
                        Spacer()
                    }
                    Spacer()
                }
                .frame(minHeight: 0, maxHeight: .infinity)
                .background(Color("bg-tab-bar"))
                .edgesIgnoringSafeArea(.bottom)
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        if (self.selection == 0) {
                            NavigationView {
                                ExploreView(tabSelection: self.$selection)
                            }
                            
                        } else if (self.selection == 1) {
                            NavigationView {
                                SearchView(tabSelection: self.$selection)
                            }
                        } else if (self.selection == 2) {
                            NavigationView {
                                ProfileView(profileUserId: self.firebaseAuthentication.currentUser!.uid, tabSelection: self.$selection)
                            }
                        }
                    }
                    .padding(.bottom, -10)
                    Spacer()
                    if (self.exploreModel.exploreList != nil && self.selection != 0) {
                        ExploreIsActiveBar(tabSelection: self.$selection)
                    }
                    CustomTabBar(selection: self.$selection)
                        .frame(width: metrics.size.width, height: 50)
                        .background(Color("bg-tab-bar"))
                }
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        TabBarView()
    }
}
