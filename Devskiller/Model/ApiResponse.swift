//
//  ApiResponse.swift
//  TescoCoding
//
//  Created by Oladipupo Oluwatobi on 28/03/2022.
//

import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    var data: ResponsePayload<T>?
    var error: ErrorMessage?
}

struct ErrorMessage: Decodable {
    let message: String?
}

