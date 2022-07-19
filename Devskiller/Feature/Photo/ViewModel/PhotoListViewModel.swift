//
//  PhotoViewModel.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 14/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import Foundation

class PhotoListViewModel: PhotoListViewModelProtocol {
    var query: String = ""
    private let photoRepo: PhotoRepoProtocol?
    private weak var delegate: PhotoViewDelegateProtocol?
    private  weak var dataSource: GenericDataSource<[PhotoSearchModel]>?
    private var seeachPhotoData: [SearchPhotoViewModel] = []
    init (photoRepo: PhotoRepoProtocol, delegate: PhotoViewDelegateProtocol, dataSource: GenericDataSource<[PhotoSearchModel]>?) {
        self.photoRepo = photoRepo
        self.delegate = delegate
        self.dataSource = dataSource
    }
    
    func searchPhoto(query: String, pageNo: String, data: @escaping (PhotoSearchModel) -> Void )  {
        Task {
            do {
                let response =  try await photoRepo?.getShearchPhotos(query: query, page: pageNo)
                if let photosData = response?.data?.photos?.photo, let photosRes = response?.data?.photos {
                    seeachPhotoData = photosData.map(SearchPhotoViewModel.init)
                    let photosDataResponse = PhotoSearchModel(searchdata: nil, SearchResponse: PhotosResponse(Photos:  photosRes), searchModel: seeachPhotoData, viewModel: self)
                    self.dataSource?.data.value.insert([photosDataResponse], at: 0)
                }
                if let errorMessage = response?.error?.message  {
                    delegate?.errorHandler(error: errorMessage)
                }
            }catch {
                delegate?.errorHandler(error: error.localizedDescription)
            }
        }
    }
    
    func searchInfiniteScrollingPhoto(query: String, pageNo: String, data: @escaping (PhotoSearchModel) -> Void) {
        Task {
            do {
                let response =  try await photoRepo?.getShearchPhotos(query: query, page: pageNo)
                if let photosData = response?.data?.photos?.photo, let photosRes = response?.data?.photos {
                    seeachPhotoData += photosData.map(SearchPhotoViewModel.init)
                    let photosDataResponse = PhotoSearchModel(searchdata: nil, SearchResponse: PhotosResponse(Photos: photosRes), searchModel:  seeachPhotoData, viewModel: self)
                    self.dataSource?.data.value.insert([photosDataResponse], at: 0)
                }
                if let errorMessage = response?.error?.message  {
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

    func loadPhotoList() -> [Data]? {
        do{
            return  try photoRepo?.loadPhotoList().map({$0.compactMap({ $0.data})})
            
        }catch {
            delegate?.errorHandler(error: error.localizedDescription)
        }
        return nil
    }
    
    func presentImage(_ indexPath: IndexPath,
                      completion: ((Data) -> Void)? = nil) {
        if let urlString = self.dataSource?.data.value.first?.first?.searchModel?[indexPath.row].flickrImageURL("b")
        {
            imageDownload(urlString: urlString) {
                completion!($0)
                self.savePhotoDetails(data: $0)
            }
            
        }
    }
}


