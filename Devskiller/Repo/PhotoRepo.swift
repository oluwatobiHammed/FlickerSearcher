//
//  PhotoRepo.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 14/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import Foundation


class PhotoRepo: PhotoRepoProtocol {

    
    
   private let route: PhotoRouteProtocol?
    private let localStorage: BaseStorageProtocol?
    init (route: PhotoRouteProtocol, localStorage: BaseStorageProtocol) {
        self.route = route
        self.localStorage = localStorage
    }
    
    func getShearchPhotos(query: String, page: String) async throws -> ApiResponse<PhotoResponse>? {
      return try await  route?.getShearchPhotos(query: query, page: page)
    }
    
    func getPhotosSize(id: String) async throws -> ApiResponse<SizeResponse<[Size]>>? {
        return try await route?.getPhotosSize(id: id)
    }
    
    func imageDownload(urlString:String)async throws -> Data? {
        return try await route?.imageDownload(urlString: urlString)
    }
    
    func savePhotoDetails(data: Data) throws  {
       try localStorage?.savePhotoDetails(data: data)
    }
    
    func savePhotoList(data: Data) throws {
        try localStorage?.savePhotoList(data: data)
    }
    
    func loadPhotoDetails() throws -> Data? {
      return  try localStorage?.loadPhotoDetails()
    }
    
    func loadPhotoList() throws -> [PhotoList]? {
      return  try localStorage?.loadPhotoList()
    }
    
    
}
