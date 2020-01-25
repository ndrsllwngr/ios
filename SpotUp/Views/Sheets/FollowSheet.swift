import SwiftUI
import FirebaseFirestore

struct FollowSheet: View {
    var userIds: [String]
    var sheetTitle: String
    
    @State var users: [User] = []
    
    @Binding var showSheet: Bool
    @Binding var profileUserIdToNavigateTo: String?
    @Binding var goToOtherProfile: Int?
    
    var body: some View {
        VStack {
            Capsule()
            .fill(Color.secondary)
            .frame(width: 30, height: 3)
            .padding(10)
            List {
                Section() {
                    Text(self.sheetTitle).font(.system(size:18)).fontWeight(.bold)
                    ForEach(self.users.sorted{$0.username.lowercased() < $1.username.lowercased()}) {(user: User) in
                        HStack {
                            HStack(alignment: .center) {
                                FirebaseProfileImage(imageUrl: user.imageUrl).frame(width: 42, height: 42)
                                    .clipShape(Circle())
                                    .padding(.trailing, 5)
                                VStack(alignment: .leading){
                                    Text(user.username).font(.system(size:18)).fontWeight(.semibold).lineLimit(1)
                                }
                                Spacer()
                            }.onTapGesture {
                                self.profileUserIdToNavigateTo = user.id
                                self.goToOtherProfile = 1
                                self.showSheet.toggle()
                            }
                            Spacer()
                            Text("")
                        }
                    }
                    Spacer()
                }
            }
            .padding()
            .onAppear {
                self.users = []
                self.userIds.forEach { userId in
                    let userRef = FirestoreConnection.shared.getUsersRef().document(userId)
                    userRef.getDocument { documentSnapshot, error in
                        guard let documentSnapshot = documentSnapshot else {
                            print("Error retrieving user")
                            return
                        }
                        documentSnapshot.data().flatMap({ data in
                            let user = dataToUser(data: data)
                            print("got user \(user)")
                            self.users.append(user)
                        })
                    }
                }
            }
            Spacer()
        }
    }
}
