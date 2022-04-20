//
//  PhotoViewModel.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 14/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import Foundation


class PhotoViewModel: PhotoViewModelProtocol {

    
    
    
    private let photoRepo: PhotoRepoProtocol?
    private weak var delegate: PhotoViewDelegateProtocol?
    init (photoRepo: PhotoRepoProtocol, delegate: PhotoViewDelegateProtocol) {
        self.photoRepo = photoRepo
        self.delegate = delegate
    }
    
    func searchPhoto(query: String, pageNo: String, data: @escaping (PhotoSearchModel) -> Void )  {
        
        Task {
            do {
                let response =  try await photoRepo?.getShearchPhotos(query: query, page: pageNo)
                
                if let photosData = response?.data?.photos?.photo, let photosRes = response?.data?.photos {
                    let photosDataResponse = PhotoSearchModel(searchdata: photosData.map(SearchPhotoViewModel.init), SearchResponse: PhotosResponse(Photos: photosRes))
                    data(photosDataResponse)
                   
                }
                
                if let errorMessage = response?.error?.message  {
                    delegate?.errorHandler(error: errorMessage)
                }
            }catch {
                delegate?.errorHandler(error: error.localizedDescription)
            }
        }
    }
    
    func getPhotSize(id: String, data: @escaping (String) -> Void) {
        Task {
            do {
                let response = try await photoRepo?.getPhotosSize(id: id)
                if let url = response?.data?.sizes?.size[1] {
                    data(url.source)
                }
                
                if let errorMessage = response?.error?.message   {
                    delegate?.errorHandler(error: errorMessage)
                }
                
            }catch {
                delegate?.errorHandler(error: error.localizedDescription)
            }
        }
    }
    
    func imageDownload (urlString: String, data: @escaping (Data) -> Void) {
        Task {
            do{
                guard let imageData = try await photoRepo?.imageDownload(urlString: urlString) else {
                    return
                }
               data(imageData)
            }catch{
                delegate?.errorHandler(error: error.localizedDescription)
            }
        }
    }
    
    
    func savePhotoDetails(data: Data) {
        do{
           try photoRepo?.savePhotoDetails(data: data)
        }catch {
            delegate?.errorHandler(error: error.localizedDescription)
        }
    }
    
    func savePhotoList(data: Data) {
        do{
            try photoRepo?.savePhotoList(data: data)
        }catch {
            delegate?.errorHandler(error: error.localizedDescription)
        }
    }
    
    func loadPhotoDetails() -> Data? {
        do{
            let data =  try photoRepo?.loadPhotoDetails()
            return data
        }catch {
            delegate?.errorHandler(error: error.localizedDescription)
        }
        return nil
    }
    
    func loadPhotoList() -> [PhotoList]? {
        do{
            return try photoRepo?.loadPhotoList()
        }catch {
            delegate?.errorHandler(error: error.localizedDescription)
        }
        return nil
    }
}


struct PhotoSearchModel {
    let searchdata: [SearchPhotoViewModel]
    let SearchResponse: PhotosResponse
}
