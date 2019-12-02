//
//  ItemMapView.swift
//  SpotUp
//
//  Created by Havy Ha on 02.12.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import MapKit
//The UIViewRepresentable protocol has two requirements: a makeUIView(context:) method that creates an MKMapView, and an updateUIView(_:context:) method that configures the view and responds to any changes.
struct ItemMapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: 34.011286, longitude: -116.166868)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
    }
}

struct ItemMapView_Previews: PreviewProvider {
    static var previews: some View {
        ItemMapView()
    }
}

