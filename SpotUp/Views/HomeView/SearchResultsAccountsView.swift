import SwiftUI

struct SearchResultsAccountsView: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        Group {
            if self.searchViewModel.searchTerm == "" {
                if (self.searchViewModel.recentSearchFirebaseAccounts.count > 0) {
                    List {
                        Section(header: Text("Recent")){ForEach(searchViewModel.recentSearchFirebaseAccounts) {
                            (user: User) in SingleRowAccount(user: user, showRecent: true).environmentObject(self.searchViewModel)
                            }
                            Spacer()
                        }
                    }
                }
                else {
                    SearchResultsEmptyStateView()
                }
            } else {
                List { ForEach(self.searchViewModel.firestoreSearch.allUsers.filter{self.searchViewModel.searchTerm.isEmpty ? false : $0.username.localizedCaseInsensitiveContains(self.searchViewModel.searchTerm)}) {
                    (user: User) in SingleRowAccount(user: user).environmentObject(self.searchViewModel)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct SingleRowAccount: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    var user: User
    @State var showRecent: Bool = false
    @State var selection: Int? = nil
    @State var goToDestination: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
                if(self.searchViewModel.recentSearchFirebaseAccounts.count == 0) {
                    self.searchViewModel.recentSearchFirebaseAccounts.append(self.user)
                } else if (!self.searchViewModel.recentSearchFirebaseAccounts.contains(self.user)) {
                    self.searchViewModel.recentSearchFirebaseAccounts.insert(self.user, at: 0)
                    if(self.searchViewModel.recentSearchFirebaseAccounts.count > 5) {
                        self.searchViewModel.recentSearchFirebaseAccounts = Array(self.searchViewModel.recentSearchFirebaseAccounts.prefix(5))
                    }
                }
                self.goToDestination = true
                self.selection = 1
            }){
                HStack {
                    Text(user.username)
                    Spacer()
                }
            }.padding(.leading)
            Spacer()
            //            if showRecent == true {
            //                Group{
            //                    Button(action: {
            //                        print("delete invoked")
            //                        let indexOfToBeDeletedEntry = self.searchViewModel.recentSearchFirebaseAccounts.firstIndex(of: self.user)
            //                        if(indexOfToBeDeletedEntry != nil) {
            //                            self.searchViewModel.recentSearchFirebaseAccounts.remove(at: indexOfToBeDeletedEntry!)
            //                        }
            //                    }) { Image(systemName: "xmark")}
            //                }
            //                .padding(.trailing)
            //            }
            if (self.goToDestination != false) {
                NavigationLink(destination: ProfileView(profileUserId: user.id), tag: 1, selection: $selection) { EmptyView() }
            }
        }
    }
}

//struct SearchResultsAccountsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultsAccountsView()
//    }
//}
