//
//  Endpoint.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 14/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

enum Method: String {
    case photosSearch = "flickr.photos.search"
    case photosGetSizes = "flickr.photos.getSizes"
}


extension Endpoint {
    static func search(matching query: String, nextPage page: String, apiKey: String,
                       method: Method) -> Endpoint {
        return Endpoint(
            path: "/services/rest/",
            queryItems: [
                URLQueryItem(name: "tags", value: query),
                URLQueryItem(name: "method", value: method.rawValue),
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "page", value: page),
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "nojsoncallback", value: "1")
            ]
        )
    }
    
    static func size(matching id: String,apiKey: String,
                     method: Method) -> Endpoint {
        return Endpoint(
            path: "/services/rest/",
            queryItems: [
                URLQueryItem(name: "photo_id", value: id),
                URLQueryItem(name: "method", value: method.rawValue),
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "nojsoncallback", value: "1")
            ]
        )
    }
    
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}
