import SwiftUI

struct SearchResultsAccountsView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    // PROPS
    @Binding var tabSelection: Int
    // LOCAL
    @State var profileIdToNavigateTo: String? = nil
    @State var goToProfile: Int? = nil
    
    var body: some View {
        VStack {
            if (self.profileIdToNavigateTo != nil) {
                NavigationLink(destination: ProfileView(profileUserId: self.profileIdToNavigateTo!, tabSelection: $tabSelection), tag: 1, selection: self.$goToProfile) {
                    EmptyView()
                }
            }
            Group {
                if self.searchViewModel.searchTerm == "" {
                    if (self.searchViewModel.recentSearchFirebaseAccounts.count > 0) {
                        List {
                            Text("Recent")
                                .font(.system(size:18))
                                .fontWeight(.bold)
                            ForEach(searchViewModel.recentSearchFirebaseAccounts) { (user: User) in
                                SingleRowAccount(user: user,
                                                 tabSelection: self.$tabSelection,
                                                 profileIdToNavigateTo: self.$profileIdToNavigateTo,
                                                 goToProfile: self.$goToProfile,
                                                 showRecent: true)
                                    .environmentObject(self.searchViewModel)
                            }
                            Spacer()
                        }
                    } else {
                        SearchResultsProfilesEmptyStateView()
                    }
                } else {
                    List {
                        ForEach(self.searchViewModel.firestoreSearch.allUsers.filter{self.searchViewModel.searchTerm.isEmpty ? false : $0.username.localizedCaseInsensitiveContains(self.searchViewModel.searchTerm)}) { (user: User) in
                            SingleRowAccount(user: user,
                                             tabSelection: self.$tabSelection,
                                             profileIdToNavigateTo: self.$profileIdToNavigateTo,
                                             goToProfile: self.$goToProfile)
                                .environmentObject(self.searchViewModel)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct SingleRowAccount: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    // PROPS
    var user: User
    @Binding var tabSelection: Int
    @Binding var profileIdToNavigateTo: String?
    @Binding var goToProfile: Int?
    @State var showRecent: Bool = false
    
    var body: some View {
        HStack {
            HStack(alignment: .center) {
                FirebaseProfileImage(imageUrl: user.imageUrl).frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.trailing, 5)
                VStack(alignment: .leading){
                    Text(user.username)
                        .font(.system(size:18))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if(self.searchViewModel.recentSearchFirebaseAccounts.count == 0) {
                    self.searchViewModel.recentSearchFirebaseAccounts.append(self.user)
                } else if (!self.searchViewModel.recentSearchFirebaseAccounts.contains(self.user)) {
                    self.searchViewModel.recentSearchFirebaseAccounts.insert(self.user, at: 0)
                    if(self.searchViewModel.recentSearchFirebaseAccounts.count > 5) {
                        self.searchViewModel.recentSearchFirebaseAccounts = Array(self.searchViewModel.recentSearchFirebaseAccounts.prefix(5))
                    }
                }
                self.profileIdToNavigateTo = self.user.id
                self.goToProfile = 1
            }
            if showRecent == true {
                Image(systemName: "xmark")
                    .padding(.trailing)
                    .frame(width: 40)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let indexOfToBeDeletedEntry = self.searchViewModel.recentSearchFirebaseAccounts.firstIndex(of: self.user)
                        if(indexOfToBeDeletedEntry != nil) {
                            self.searchViewModel.recentSearchFirebaseAccounts.remove(at: indexOfToBeDeletedEntry!)
                        }
                }
            }
        }
    }
}
