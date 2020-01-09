import SwiftUI

struct SearchResultsAccounts: View {
    @EnvironmentObject var searchSpace: FirestoreSearch
    //    @ObservedObject var firestorePlaceList = FirestorePlaceList()
    @State var searchTerm: String
    
    var body: some View {
        List { ForEach(searchSpace.allUsers.filter{self.searchTerm.isEmpty ? false : $0.username.localizedCaseInsensitiveContains(self.searchTerm)}) {
            (user: User) in NavigationLink(destination: ProfileView(profileUserId: user.id)){Text(user.username)}
            }
            Spacer()
        }
    }
}

//struct AccountsResults_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountsResults()
//    }
//}
