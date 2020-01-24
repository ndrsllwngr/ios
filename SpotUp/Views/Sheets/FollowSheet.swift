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
            Text(self.sheetTitle)
            List {
                ForEach(self.users.sorted{$0.username.lowercased() < $1.username.lowercased()}) {(user: User) in
                    Button(action: {
                        self.profileUserIdToNavigateTo = user.id
                        self.goToOtherProfile = 1
                        self.showSheet.toggle()
                    }) {
                        Text(user.username)}
                }
                Spacer()
            }
            Spacer()
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
    }
}
