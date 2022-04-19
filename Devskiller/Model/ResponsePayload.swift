//
//  ResponsePayload.swift
//  TescoCoding
//
//  Created by Oladipupo Oluwatobi on 14/04/2022.
//

import Foundation
// MARK: - ResponsePayload

/// The ``ResponsePayload`` is a generic type which represents a payload received from an API request.
struct ResponsePayload<T: Decodable>: Decodable {

    let  photos: T?
    let  sizes: T?
               
}


struct PhotoResponse: Decodable  {
    let photo: [Photo]
    let page: Int
    let pages: Int
}

struct SizeResponse<T: Decodable>: Decodable  {
    let size: T
}
