import SwiftUI

struct CreateNewPlaceListRow: View {
    @EnvironmentObject var firestoreProfile: FirestoreProfile
    // PROPS
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                HStack {
                    Image(systemName: "plus.rectangle.on.rectangle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
                }
                .frame(width: 100, height: 60)
                Text("Create new collection")
            }
            .frame(width: geo.size.width, alignment: .leading)
            .background(Color("elevation-1"))
            .mask(Rectangle().cornerRadius(15))
            .padding(.vertical)
        }
        .frame(height: 60)
        .contentShape(Rectangle())
        .onTapGesture {
            self.firestoreProfile.removeProfileListener()
            self.sheetSelection = "create_placelist"
            self.showSheet.toggle()
        }
    }
}

struct PlaceListRow: View {
    // PROPS
    var placeList: PlaceList
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack {
                    FirebasePlaceListRowImage(imageUrl: self.placeList.imageUrl)
                        .scaledToFill()
                        .frame(width: 100, height: 60)
                    
                    VStack(alignment: .leading) {
                        Text(self.placeList.name)
                            .font(.system(size: 18))
                            .bold()
                            .lineLimit(1)
                        Text("by \(self.placeList.owner.username)")
                            .font(.system(size: 12))
                            .lineLimit(1)
                        
                    }
                    .padding(.trailing)
                }
                .frame(width: geo.size.width, height: 60, alignment: .leading)
                .background(Color("elevation-1"))
                .mask(Rectangle().cornerRadius(15))
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if (!self.placeList.isPublic) {
                            HStack {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 10)
                            }
                            .frame(width: 20, height: 20)
                            .background(Color("bg-placeholder"))
                            .mask(Circle())
                        }
                        if (self.placeList.isCollaborative) {
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10)
                            }
                            .frame(width: 20, height: 20)
                            .background(Color("bg-placeholder"))
                            .mask(Circle())
                        }
                    }
                    .padding(.trailing)
                    .padding(.bottom, 10)
                }
                .frame(width: geo.size.width, height: 60, alignment: .trailing)
            }
        }
        .frame(height: 60)
    }
}
