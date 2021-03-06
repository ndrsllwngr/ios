import SwiftUI
import FirebaseFirestore
import GooglePlaces

struct AddPlaceToListSheet: View {
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    //PROPS
    var place: GMSPlace
    var placeImage: UIImage?
    
    @Binding var showSheet: Bool
    // LOCAL
    @State var placeLists: [PlaceList] = []
    @State var isLoading = false
    
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 30, height: 3)
                .padding(10)
            VStack {
                HStack {
                    Text("Add to collection").font(.system(size:18)).fontWeight(.bold)
                    Spacer()
                }
                if (isLoading) {
                    Spacer()
                    ActivityIndicator()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("text-secondary"))
                } else {
                    if (!self.placeLists.isEmpty) {
                        ScrollView {
                            ForEach(sortPlaceLists(placeLists: self.placeLists.filter{ $0.owner.id == self.firebaseAuthentication.currentUser!.uid || $0.isCollaborative}, sortByCreationDate: true)){ placeList in
                                PlaceListRow(placeList: placeList)
                                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color("border-tab-bar"), lineWidth: 1))
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        FirestoreConnection.shared.addPlaceToList(placeList: placeList, placeId: self.place.placeID!, placeImage: self.placeImage)
                                        self.showSheet.toggle()
                                }
                            }
                        }
                        .animation(.easeInOut)
                        .transition(.asymmetric(insertion: .scale, removal: .scale))
                    } else {
                        Spacer()
                        Text("No collections found")
                            .foregroundColor(Color("text-secondary"))
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .onAppear {
            self.isLoading = true
            self.placeLists = []
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            let query = FirestoreConnection.shared.getPlaceListsRef().whereField("follower_ids", arrayContains: self.firebaseAuthentication.currentUser!.uid)
            query.getDocuments { querySnapshot, error in
                guard let querySnapshot = querySnapshot else {
                    print("Error retrieving Lists")
                    self.isLoading = false
                    return
                }
                dispatchGroup.leave()
                self.placeLists = querySnapshot.documents.map { (documentSnapshot) in
                    let data = documentSnapshot.data()
                    return dataToPlaceList(data: data)
                }
                self.isLoading = false
                for (i, placeList) in self.placeLists.enumerated() {
                    dispatchGroup.enter()
                    FirestoreConnection.shared.getUsersRef().document(placeList.owner.id).getDocument { documentSnapshot, error in
                        guard let documentSnapshot = documentSnapshot else {
                            print("Error retrieving user")
                            return
                        }
                        documentSnapshot.data().flatMap({ data in
                            let username = data["username"] as! String
                            if self.placeLists.count > i {
                                self.placeLists[i].owner.username = username
                            }
                            dispatchGroup.leave()
                        })
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.isLoading = false
            }
        }
    }
}
