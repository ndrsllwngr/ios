import SwiftUI

struct SearchResultsAccountsView: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        Group {
            if self.searchViewModel.searchTerm == "" {
                if (self.searchViewModel.recentSearchFirebaseAccounts.count > 0) {
                    List { Section(header: Text("Recent")){
                        ForEach(searchViewModel.recentSearchFirebaseAccounts, id: \.self.id) {
                            (user: User) in SingleRowAccount(user: user).environmentObject(self.searchViewModel)
                        }.onDelete(perform: delete)
                        Spacer()
                        }
                    }
                    
                }
                else {
                    SearchResultsEmptyStateView()
                }
            } else {
                List { ForEach(self.searchViewModel.firestoreSearch.allUsers.filter{self.searchViewModel.searchTerm.isEmpty ? false : $0.username.localizedCaseInsensitiveContains(self.searchViewModel.searchTerm)}, id: \.self.id) {
                    (user: User) in SingleRowAccount(user: user).environmentObject(self.searchViewModel)
                    }
                    Spacer()
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        self.searchViewModel.recentSearchFirebaseAccounts.remove(atOffsets: offsets)
    }
}

struct SingleRowAccount: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    @State var user: User
    @State var presentMe: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
                if(self.searchViewModel.recentSearchFirebaseAccounts.count == 0) {
                    self.searchViewModel.recentSearchFirebaseAccounts.append(self.user)
                } else if (!self.searchViewModel.recentSearchFirebaseAccounts.contains(self.user)) {
                    self.searchViewModel.recentSearchFirebaseAccounts.insert(self.user, at: 0)
                }
                self.presentMe = true
            }, label: {
                Text(user.username)
            })
            NavigationLink(destination: ProfileView(profileUserId: user.id), isActive: self.$presentMe){ EmptyView() }
        }
    }
}

//struct SearchResultsAccountsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultsAccountsView()
//    }
//}
