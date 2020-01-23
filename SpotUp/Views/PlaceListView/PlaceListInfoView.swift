import Foundation
import SwiftUI

struct PlaceListInfoView: View {
    
    var placeListId: String
    
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    @Binding var tabSelection: Int
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            HStack (alignment: .top){
                FirebasePlaceListInfoImage(imageUrl: self.firestorePlaceList.placeList.imageUrl)
                    .clipShape(Rectangle())
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
                
                HStack (alignment: .top){
                    VStack (alignment: .leading){
                        Text(self.firestorePlaceList.placeList.name)
                            .font(Font.custom("Europa-Bold", size: 20))
                        HStack {
                            NavigationLink(destination: ProfileView(profileUserId: self.firestorePlaceList.placeList.owner.id, tabSelection: self.$tabSelection)) {
                                Text("by \(self.firestorePlaceList.placeList.owner.username)")
                                    .font(Font.custom("Europa-Regular", size: 12))
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "map")
                                    .frame(height: 16)
                                Text("\(self.firestorePlaceList.placeList.places.map{$0.placeId}.count)")
                                    .font(Font.custom("Europa-Regular", size: 12))
                            }
                            Spacer()
                            Button(action: {
                                self.sheetSelection = "follower"
                                self.showSheet.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "person")
                                        .frame(height: 16)
                                    Text("\(self.firestorePlaceList.placeList.followerIds.filter{$0 != self.firestorePlaceList.placeList.owner.id}.count)")                                .font(Font.custom("Europa-Regular", size: 12))
                                }
                            }
                        }
                        Spacer()
                        Button(action: {
                            ExploreModel.shared.startExploreWithPlaceList(placeList: self.firestorePlaceList.placeList, places: self.firestorePlaceList.places.map{$0.gmsPlace})
                            self.tabSelection = 2
                        }) {
                            VStack{
                                Text("Explore")
                                    .accentColor(Color.white)
                                    .padding([.vertical], 5)
                                    .padding([.horizontal], 32)
                            }.background(Color("brand-color-primary"))
                                .cornerRadius(15)
                        }
                        Spacer()
                    }
                    .frame(height: 100)
                    .padding(.leading, 10)
                }
            }.padding(.horizontal, 22)
        }
    }
}
