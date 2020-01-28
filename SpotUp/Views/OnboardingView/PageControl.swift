import Foundation
import UIKit
import SwiftUI

struct PageControl: UIViewRepresentable {
    // PROPS
    @Binding var currentPageIndex: Int
    var numberOfPages: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.currentPageIndicatorTintColor = UIColor.orange
        control.pageIndicatorTintColor = UIColor.gray
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPageIndex
    }
}
