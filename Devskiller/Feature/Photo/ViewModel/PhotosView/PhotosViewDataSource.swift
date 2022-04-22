//
//  PhotosViewDataSource.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 20/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import Foundation
import UIKit

class GenericDataSource<T>: NSObject {
    var data = DynamicValue<[T]>([])
}

@available(iOS 15.0, *)
class PhotosViewDataSource: GenericDataSource<[PhotoSearchModel]>, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.first?.first?.searchModel?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell
        guard let cell = cell else {
            return UICollectionViewCell()
        }
        if let urlString = data.value.first?.first?.searchModel?[indexPath.row].flickrImageURL() {
            let _ = data.value.first?.first?.viewModel?.imageDownload(urlString: urlString, data: {
                self.data.value.first?.first?.viewModel?.savePhotoList(data: $0)
                cell.photoImageView.load(data: $0)
            })
            
        }else {
            guard let data = self.data.value.first?.first?.viewModel?.loadPhotoList()?[indexPath.row] else {
                return cell
            }
            cell.photoImageView.load(data:data)
        }
       
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.5
        return cell
    }
    
   // func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let dataGeneric = data?.value else {
//            return
//        }
//        if let urlString = dataGeneric[indexPath.row].flickrImageURL("b")  {
//            selectedIndex(urlString: urlString) { [weak self] in
////                guard let self = self  else {
////                    return
////                }
//                
//                let _ = StoryBoardsID.boardMain.requestNavigation(to: ViewControllerID.ImageViewController, from: PhotoListViewController(), requestData: $0)
//            }
//        }else {
////            guard let data: Data = dataGeneric.photoViewModel?.loadPhotoDetails() else {
////                return
////            }
//            let _ = StoryBoardsID.boardMain.requestNavigation(to: ViewControllerID.ImageViewController, from: PhotoListViewController(), requestData: data)
//        }
//        
//        collectionView.deselectItem(at: indexPath, animated: true)
   // }
    
   // func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard var data = data.value else {
//            return
//        }
        //if data.SearchResponse.page <  data.SearchResponse.pages && indexPath.row == (data.searchdata?.count ?? 1) - 1 {
            //data.currentPage += 1
            //data.isSearching = true
            //data.photoViewModel?.searchPhoto(query: data.query, pageNo: "\(data.currentPage)", data: { [weak self] in
                //data.searchdata! += $0.searchdata!
               // collectionView.reloadData()
//                self?.activityIndicator.stopAnimating()
//                self?.activityIndicator.removeFromSuperview()
            //})
       // }
   // }
    
    
//        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            var currentPage:Int = 1
//            guard let reqphoto = data.value.first?.first?.SearchResponse, var requData = data.value.first?.first?.searchModel else {
//                return
//            }
//            if reqphoto.page <  reqphoto.pages && indexPath.row == requData.count - 1 {
//                 currentPage += 1
//                //self.isSearching = true
//                data.value.first?.first?.viewModel?.searchPhoto(query: "Kitten", pageNo: "\(2 + 1)", data: {
//                    guard let searchData = $0.searchModel else {
//                        return
//                    }
//                    requData += searchData
//                    collectionView.reloadData()
//////                    self?.activityIndicator.stopAnimating()
//////                    self?.activityIndicator.removeFromSuperview()
//                })
//            }
//        }
    
}
