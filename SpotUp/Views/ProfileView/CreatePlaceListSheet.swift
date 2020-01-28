import SwiftUI
import FirebaseFirestore

struct CreatePlacelistSheet: View {
    var user: User
    @Binding var showSheet: Bool
    
    @ObservedObject private var createPlacelistViewModel = CreatePlacelistViewModel()
    
    var buttonColor: Color {
        return self.createPlacelistViewModel.isValidplacelist ? Color("brand-color-primary") : Color(.lightGray)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 30, height: 3)
                .padding(.top, 10)
                .padding(.bottom, 40)
            
            Text("Enter a name for your new collection")
            Spacer()
            
            VStack (alignment: .leading){
                TextField("Collection Name", text: self.$createPlacelistViewModel.placelistName)
                    .autocapitalization(.none)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(.lightGray))
                    .opacity(0.8)
                
                Text(self.createPlacelistViewModel.placelistNameMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
                Spacer()
            }.frame(height: 60)
                .padding(.horizontal, 30)
            
            HStack {
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    GeometryReader { geo in
                        Text("Cancel")
                            .foregroundColor(Color(.gray))
                            .frame(width: geo.size.width, height: 40)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(.gray), lineWidth: 1))
                            .padding(.top, 20)
                    }.frame(height: 40)
                }
                Spacer()
                Button(action: {
                    let newPlaceList = PlaceList(name: self.createPlacelistViewModel.placelistName, owner: self.user.toListOwner(), followerIds: [self.user.id], createdAt:Timestamp())
                    FirestoreConnection.shared.createPlaceList(placeList: newPlaceList)
                    self.showSheet.toggle()
                }) {
                    GeometryReader { geo in
                        Text("Create")
                            .foregroundColor(self.buttonColor)
                            .frame(width: geo.size.width, height: 40)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(self.buttonColor, lineWidth: 1))
                            .padding(.top, 20)
                    }.frame(height: 40)
                }.disabled(!self.createPlacelistViewModel.isValidplacelist)
            }
            .frame(height: 100)
            .padding(.horizontal, 30)
            Spacer()
        }
    }
}
