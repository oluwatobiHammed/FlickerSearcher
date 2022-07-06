//
//  PhotosModel.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 20/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import Foundation



struct PhotoSearchModel {
    let searchdata: [Data]?
    let SearchResponse: PhotosResponse
    let searchModel: [SearchPhotoViewModel]?
    let viewModel: PhotoListViewModelProtocol?
}


@available(iOS 15.0, *)
struct PhotosModel {
    var searchdata: [Data]?
    let SearchResponse: PhotosResponse?
}
