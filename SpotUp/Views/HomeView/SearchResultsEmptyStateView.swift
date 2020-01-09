//
//  SearchResultsEmptyStateView.swift
//  SpotUp
//
//  Created by Andreas Ellwanger on 09.01.20.
//

import SwiftUI

struct SearchResultsEmptyStateView: View {
    var body: some View {
        VStack() {
            Spacer()
            Text("Empty state")
            Spacer()
        }
    }
}

struct SearchResultsEmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsEmptyStateView()
    }
}
