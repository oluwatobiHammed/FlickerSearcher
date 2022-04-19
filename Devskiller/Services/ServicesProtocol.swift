//
//  ServicesProtocol.swift
//  TescoCoding
//
//  Created by Oladipupo Oluwatobi on 22/03/2022.
//

import Foundation

protocol  ServicesProtocol {
    func baseNetwork<ResponseType: Decodable>(_ endpoint: Endpoint,method: HttpMethod, responseType: ResponseType.Type) async throws -> ResponseType?
    func imageDownload(_ urlString: String,method: HttpMethod) async throws -> Data?
}

