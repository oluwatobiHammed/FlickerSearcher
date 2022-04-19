//
//  color.swift
//  TescoCoding
//
//  Created by Oladipupo Oluwatobi on 22/03/2022.
//

import Foundation


struct Photo: Codable {
    /// The type which represents the ID of a ``Photo``.
    typealias ID = String
    
    /// The unique identifier of the photo.
    let id: ID?
    let owner: String?
    let secret: String?
    let server: String?
}

