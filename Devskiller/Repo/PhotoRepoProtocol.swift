//
//  PotoRepoProtocol.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 14/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import Foundation

protocol PhotoRepoProtocol {
    func getShearchPhotos(query: String, page: String) async throws -> ApiResponse<PhotoResponse>?
    func getPhotosSize(id: String) async throws -> ApiResponse<SizeResponse<[Size]>>?
    func imageDownload(urlString:String)async throws -> Data?
    func savePhotoDetails(data: Data) throws
    func savePhotoList (data: Data) throws
    func loadPhotoDetails() throws -> Data?
    func loadPhotoList() throws -> [PhotoList]?
    func deletePhotoList<T:PhotoList>(photos: T)
    func deletePhotoDetails<T:PhotoDetail>(photo: T)
    
}
