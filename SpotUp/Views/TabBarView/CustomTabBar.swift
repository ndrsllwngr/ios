import SwiftUI

struct CustomTabBar: View {
    // PROPS
    @Binding var selection: Int
    
    var body: some View {
        HStack {
            GeometryReader{ geo in
                VStack {
                    Image(systemName: "map")
                        .foregroundColor(self.selection == 0 ? Color("brand-color-primary") : Color("text-secondary"))
                    Text("Explore")
                        .foregroundColor(self.selection == 0 ? Color("brand-color-primary") : Color("text-secondary"))
                        .font(.footnote)
                    
                }
                .onTapGesture {
                    self.selection = 0
                }.frame(width: geo.size.width)
                .padding(.top, 5)
            }
            GeometryReader{ geo in
                VStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(self.selection == 1 ? Color("brand-color-primary") : Color("text-secondary"))
                    Text("Search")
                        .foregroundColor(self.selection == 1 ? Color("brand-color-primary") : Color("text-secondary"))
                        .font(.footnote)
                }
                .onTapGesture {
                    self.selection = 1
                }.frame(width: geo.size.width)
                .padding(.top, 5)
                
            }
            GeometryReader{ geo in
                VStack {
                    Image(systemName: "person")
                        .foregroundColor(self.selection == 2 ? Color("brand-color-primary") : Color("text-secondary"))
                    Text("Profile")
                        .foregroundColor(self.selection == 2 ? Color("brand-color-primary") : Color("text-secondary"))
                        .font(.footnote)
                }
                .onTapGesture {
                    self.selection = 2
                }
                .frame(width: geo.size.width)
                .padding(.top, 5)
            }
        }
    }
}
