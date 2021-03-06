import SwiftUI
import FirebaseFirestore

struct FollowSheet: View {
    // PROPS
    var userIds: [String]
    var sheetTitle: String
    @Binding var showSheet: Bool
    @Binding var profileUserIdToNavigateTo: String?
    @Binding var goToOtherProfile: Int?
    
    // LOCAL
    @State var users: [User] = []
    @State var isLoading = false
    
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 30, height: 3)
                .padding(10)
            VStack {
                HStack {
                    Text(self.sheetTitle).font(.system(size:18)).fontWeight(.bold)
                    Spacer()
                }
                if (self.userIds.isEmpty) {
                    Spacer()
                    Text("None found")
                        .foregroundColor(Color("text-secondary"))
                } else if (isLoading) {
                    Spacer()
                    ActivityIndicator()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("text-secondary"))
                } else {
                    ScrollView {
                        ForEach(self.users.sorted{$0.username.lowercased() < $1.username.lowercased()}) {(user: User) in
                            HStack(alignment: .center) {
                                FirebaseProfileImage(imageUrl: user.imageUrl).frame(width: 42, height: 42)
                                    .clipShape(Circle())
                                    .padding(.trailing, 5)
                                VStack(alignment: .leading){
                                    Text(user.username).font(.system(size:18)).fontWeight(.semibold).lineLimit(1)
                                }
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.profileUserIdToNavigateTo = user.id
                                self.goToOtherProfile = 1
                                self.showSheet.toggle()
                            }
                        }
                    }
                    .animation(.easeInOut)
                    .transition(.asymmetric(insertion: .scale, removal: .scale))
                }
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .onAppear {
            self.isLoading = true
            self.users = []
            self.userIds.forEach { userId in
                let userRef = FirestoreConnection.shared.getUsersRef().document(userId)
                userRef.getDocument { documentSnapshot, error in
                    guard let documentSnapshot = documentSnapshot else {
                        print("Error retrieving user")
                        self.isLoading = false
                        return
                    }
                    documentSnapshot.data().flatMap({ data in
                        let user = dataToUser(data: data)
                        self.users.append(user)
                    })
                    self.isLoading = false
                }
            }
        }
    }
}
