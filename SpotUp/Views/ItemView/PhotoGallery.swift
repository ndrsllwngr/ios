//
//  PhotoGallery.swift
//  SpotUp
//
//  Created by Havy Ha on 18.01.20.
//

import Foundation
import GooglePlaces
import SwiftUI

class Gallery:ObservableObject{
    @Published var gallery:[UIImage] = []
    
    func getGallery (images:[GMSPlacePhotoMetadata]?){
        if let images = images{
        var count = 0
        for image in images{
            if count < 5 {
                getPlaceFoto(photoMetadata: image){ (photo: UIImage?, error: Error?) in
                    if let error = error {
                        print("Error loading photo metadata: \(error.localizedDescription)")
                        return
                    }
                    if let photo = photo {
                        self.gallery.append(photo)
                        count+=1
                        print(count)
                        
                                           }
                }
            }
            else {
                return
            }
        }
        
        }}
}
