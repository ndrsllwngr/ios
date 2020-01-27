import SwiftUI

struct ContentView: View {
    // LOCAL
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @State var launchedBefore = false
    @State var permissionRequestedBefore = false
    
    var body: some View {
        Group {
            if firebaseAuthentication.startUpInProgress {
                SplashScreen()
                    .animation(.easeInOut)
                    .transition(.asymmetric(insertion: .scale, removal: .scale))
            } else {
                if !self.launchedBefore {
                    OnboardingView(launchedBefore: $launchedBefore)
                } else if !self.permissionRequestedBefore {
                    PermissionView(permissionRequestedBefore: $permissionRequestedBefore)
                } else if firebaseAuthentication.currentUser != nil {
                    TabBarView()
                } else {
                    AuthenticationView()
                }
            }
        }
        .onAppear(){
            self.startUp()
        }
    }
    
    func startUp() {
        self.launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        self.permissionRequestedBefore = UserDefaults.standard.bool(forKey: "permissionRequestedBefore")
        getUser()
    }
    
    func getUser() {
        FirebaseAuthentication.shared.listen()
    }
    
    func setLaunchedBefore() {
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
