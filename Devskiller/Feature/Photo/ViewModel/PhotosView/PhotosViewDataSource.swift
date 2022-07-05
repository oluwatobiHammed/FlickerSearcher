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
                cell.setUp(data: $0)
            })
            
        }else {
            guard let data = self.data.value.first?.first?.viewModel?.loadPhotoList()?[indexPath.row] else {
                return cell
            }
            cell.setUp(data: data)
        }
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    
    
}
