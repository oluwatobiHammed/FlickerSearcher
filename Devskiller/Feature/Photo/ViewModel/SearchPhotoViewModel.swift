//
//  SearchPhotoViewModel.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 17/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import Foundation


struct SearchPhotoViewModel {
    
    let photos: Photo
    
    var photoID: String {
        photos.id ?? ""
    }
    var owner: String {
        photos.owner ?? ""
    }
    var secret: String {
        photos.secret ?? ""
    }
    var server: String {
        photos.server ?? ""
    }
    
    func flickrImageURL(_ size: String = "q") -> String? {
      return "https://live.staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg"
    }
    
    func flickrLargeImageURL(_ size: String = "") -> String? {
      return "https://live.staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg"
    }
}


struct PhotosResponse {
    let Photos: PhotoResponse
    
    var page: Int {
        Photos.page
    }
    var pages: Int {
        Photos.pages
    }
    
}
