//
//  CustomSearchBar.swift
//  SpotUp
//
//  Created by Andreas Ellwanger on 21.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct CustomSearchBar: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<CustomSearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar,
                      context: UIViewRepresentableContext<CustomSearchBar>) {
        uiView.text = text
    }
    
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }


}
struct CustomSearchBar_Previews: PreviewProvider {
    @State static var searchQuery: String = ""
    static var previews: some View {
        CustomSearchBar(text: $searchQuery)
    }
}
