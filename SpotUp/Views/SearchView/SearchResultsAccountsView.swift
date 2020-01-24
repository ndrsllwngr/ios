import SwiftUI

struct SearchResultsAccountsView: View {
    
    @Binding var tabSelection: Int
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        Group {
            if self.searchViewModel.searchTerm == "" {
                if (self.searchViewModel.recentSearchFirebaseAccounts.count > 0) {
                    List {
                        Section() {
                            Text("Recent").font(.subheadline).fontWeight(.semibold)
                            ForEach(searchViewModel.recentSearchFirebaseAccounts) {
                                (user: User) in SingleRowAccount(user: user, tabSelection: self.$tabSelection, showRecent: true).environmentObject(self.searchViewModel)
                            }
                            Spacer()
                        }
                    }
                }
                else {
                    SearchResultsProfilesEmptyStateView()
                }
            } else {
                List {
                    ForEach(self.searchViewModel.firestoreSearch.allUsers.filter{self.searchViewModel.searchTerm.isEmpty ? false : $0.username.localizedCaseInsensitiveContains(self.searchViewModel.searchTerm)}) { (user: User) in
                        SingleRowAccount(user: user, tabSelection: self.$tabSelection).environmentObject(self.searchViewModel)
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
    @Binding var tabSelection: Int
    
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
                HStack(alignment: .center) {
                    FirebaseProfileImage(imageUrl: user.imageUrl).frame(width: 42, height: 42)
                        .clipShape(Circle())
                    Text(user.username).font(.body)
                    Spacer()
                }
            }.padding(.leading)
            Spacer()
            if showRecent == true {
                Group{
                    Button(action: {
                        print("delete invoked")
                        let indexOfToBeDeletedEntry = self.searchViewModel.recentSearchFirebaseAccounts.firstIndex(of: self.user)
                        if(indexOfToBeDeletedEntry != nil) {
                            self.searchViewModel.recentSearchFirebaseAccounts.remove(at: indexOfToBeDeletedEntry!)
                        }
                    }) { Image(systemName: "xmark")}
                }
                .padding(.trailing)
            }
            if (self.goToDestination != false) {
                NavigationLink(destination: ProfileView(profileUserId: user.id, tabSelection: $tabSelection), tag: 1, selection: $selection) {
                    EmptyView()
                }
            }
        }
    }
}
