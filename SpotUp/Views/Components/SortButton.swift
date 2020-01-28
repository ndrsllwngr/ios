import SwiftUI

struct SortButton: View {
    // PROPS
    @Binding var sortByDate: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.up.arrow.down")
            Image(systemName: sortByDate ? "textformat.abc" : "calendar")
        }
        .foregroundColor(.blue)
        .frame(width: 50, height: 25)
        .contentShape(Rectangle())
        .onTapGesture {
            self.sortByDate.toggle()
        }
    }
}
