//
//  SearchRouteProtocol.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 14/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import Foundation
import Foundation


protocol PhotoRouteProtocol {
    func getShearchPhotos(query: String, page: String) async throws -> ApiResponse<PhotoResponse>?
    func getPhotosSize(id: String) async throws -> ApiResponse<SizeResponse<[Size]>>?
    func imageDownload(urlString:String)async throws -> Data?
}
