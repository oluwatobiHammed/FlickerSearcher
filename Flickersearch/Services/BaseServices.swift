//
//  BaseServices.swift
//  TescoCoding
//
//  Created by Oladipupo Oluwatobi on 22/03/2022.
//

import Foundation

enum ApiError: Error {
    case badUrl
    case badData
    case InvalidServerResponse
    case DecodingError(String)
}

enum HttpMethod: String {
    case GET
    case POST
    case PUT
}

class BaseServices: ServicesProtocol {
    private lazy var session: URLSession = {
        // Set In-Memory Cache to 512 MB
        URLCache.shared.memoryCapacity = 512 * 1024 * 1024
        
        // Create URL Session Configuration
        let configuration = URLSessionConfiguration.default
        
        // Define Request Cache Policy
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        return URLSession(configuration: configuration)
    }()
    
    func baseNetwork<ResponseType: Decodable>(_ endpoint: Endpoint, method: HttpMethod, responseType: ResponseType.Type) async throws -> ResponseType {
        guard let url = endpoint.url else { throw ApiError.badUrl}
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        var responseObject = ""
        if #available(iOS 15.0, *) {
            let (data, response) = try await  session.data(for: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {throw ApiError.InvalidServerResponse}
            responseObject = "\(String(decoding: data, as: UTF8.self))"
            
        } else {
            // Fallback on earlier versions
        }
        let jsonString = responseObject.localizedCaseInsensitiveContains("fail") ?
        try self.getJsonString(withKey: "error", forValue: responseObject) :
        try self.getJsonString(withKey: "data", forValue: responseObject)
        //map the result of `jsonString` above to the `responseType`
        guard let response = try? responseType.mapTo(jsonString: jsonString) else { throw ApiError.InvalidServerResponse}
        return response
       
        
    }
    
    func imageDownload(_ urlString: String, method: HttpMethod) async throws -> Data? {
        guard let url = URL(string: urlString) else { throw ApiError.badUrl}
        var request = URLRequest(url: url)
        var data = Data()
        var response = URLResponse()
        request.httpMethod = method.rawValue
        if #available(iOS 15.0, *) {
            (data, response) = try await  session.data(for: request)
            
        } else {
            // Fallback on earlier versions
        }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {throw ApiError.InvalidServerResponse}
        return data
    }
    
    fileprivate func getJsonString(withKey: String, forValue: String) throws -> String {
        let jsonStringDictionary = "{\"\(withKey)\": \(forValue)}"
        return jsonStringDictionary
    }
}






