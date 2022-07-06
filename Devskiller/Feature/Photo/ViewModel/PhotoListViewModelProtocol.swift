//
//  PhotoViewModelProtocol.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 14/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import Foundation
@MainActor
protocol PhotoListViewModelProtocol {
    var query: String {set get}
    func searchPhoto(query: String, pageNo: String, data: @escaping (PhotoSearchModel) -> Void)
    func searchInfiniteScrollingPhoto(query: String, pageNo: String, data: @escaping (PhotoSearchModel) -> Void)
    func getPhotSize(id: String, data: @escaping (String) -> Void)
    func imageDownload (urlString: String, data: @escaping (Data) -> Void)
    func savePhotoDetails(data: Data)
    func savePhotoList (data: Data)
    func loadPhotoDetails()  -> Data?
    func loadPhotoList()  -> [Data]?
    func presentImage(_ indexPath: IndexPath,
                        completion: ((Data) -> Void)?)
    func deletePhotoList()
    func deletePhotoDetails()
}
