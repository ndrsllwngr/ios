import SwiftUI

struct SplashScreen: View {
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(uiImage: UIImage(named: "logo-icon-100")!)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(height: 102, alignment: .center)
                Spacer()
            }
            Spacer()
        }
        .frame(minHeight: 0, maxHeight: .infinity)
        .background(Color("brand-color-primary"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        SplashScreen()
    }
}
