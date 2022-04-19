//
//  SearchRoute.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 14/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import Foundation


class PhotoRoute: PhotoRouteProtocol {
   
    
    private let apiKey: String = "f9cc014fa76b098f9e82f1c288379ea1"
    private let service: ServicesProtocol?
    init (service: ServicesProtocol) {
        self.service = service
    }
    
    func getShearchPhotos(query: String, page: String) async throws -> ApiResponse<PhotoResponse>? {
        return  try await  service?.baseNetwork(.search(matching: query, nextPage: page, apiKey: apiKey, method: .photosSearch), method: .GET, responseType: ApiResponse<PhotoResponse>.self)
    }
    
    func getPhotosSize(id: String) async throws -> ApiResponse<SizeResponse<[Size]>>? {
        return  try await  service?.baseNetwork(.size(matching: id, apiKey: apiKey, method: .photosGetSizes), method: .GET, responseType: ApiResponse<SizeResponse<[Size]>>.self)
    }
    
    func imageDownload(urlString:String)async throws -> Data? {
        return try await service?.imageDownload(urlString, method: .GET)
    }
    
}
