//
//  ListsResults.swift
//  SpotUp
//
//  Created by Andreas Ellwanger on 22.12.19.
//

import SwiftUI

struct ListsResults: View {
    @Binding var searchQuery: String
    var body: some View {
        Text(searchQuery)
    }
}

struct ListsResults_Previews: PreviewProvider {
    @State static var searchQuery = "timo"
    static var previews: some View {
        ListsResults(searchQuery: $searchQuery)
    }
}
