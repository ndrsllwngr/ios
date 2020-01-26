import SwiftUI


struct SortButton: View {
    
    @Binding var sortByDate: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.up.arrow.down")
            Image(systemName: sortByDate ? "calendar" : "textformat.abc")
        }
        .foregroundColor(.blue)
        .frame(width: 50, height: 25)
        .contentShape(Rectangle())
        .onTapGesture {
            self.sortByDate.toggle()
        }
    }
}
