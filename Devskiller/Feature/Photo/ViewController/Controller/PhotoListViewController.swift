//
//  ViewController.swift
//  Devskiller
//
//  Created by Ivo Silva on 18/09/2020.
//  Copyright © 2020 Mindera. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 15.0, *)
class PhotoListViewController: BaseViewController, PhotoViewDelegateProtocol {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var photoViewModel: PhotoViewModelProtocol?
    private let itemsPerRow: CGFloat = 2
    private var requestData: [SearchPhotoViewModel]?
    private var requestPhotoList: [Data] = []
    private var requestPhoto: PhotosResponse?
    private var currentPage: Int = 1
    private var isSearching: Bool = false
    private let photoList = PhotoList(context: PersistenceService.context)
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    private var query: String =  "kitten"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if photoViewModel == nil {
            let service = BaseServices()
            let route = PhotoRoute(service: service)
            let storage = BaseStorage()
            let repo = PhotoRepo(route: route, localStorage: storage)
            photoViewModel = PhotoViewModel(photoRepo: repo, delegate: self)
        }
        
        handleSearch(query: query)
        
        
    }
    
    private func handleSearch(query: String) {
        photoViewModel?.searchPhoto(query:query, pageNo: "\(currentPage)", data: { [weak self] in
            PersistenceService.context.delete(self!.photoList)
            self?.requestData = $0.searchdata
            self?.requestPhoto = $0.SearchResponse
            $0.searchdata.forEach {
                self?.photoViewModel?.imageDownload(urlString: $0.flickrImageURL() ?? "", data: {  [weak self] in
                    self?.photoViewModel?.savePhotoList(data: $0)
                })
                
            }
            
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.removeFromSuperview()
            self?.collectionView.reloadData()
            self?.collectionView.layoutIfNeeded()
            self?.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
        })
        guard let getPhotoList = photoViewModel?.loadPhotoList() else {
            return
        }
        let dataList: [Data] = getPhotoList.compactMap({
            self.collectionView.reloadData()
            guard let data = $0.data else {
                return nil
            }
            return data
        })
        requestPhotoList = dataList
    }
    func errorHandler(error: String) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        if requestPhotoList.isEmpty || isSearching {
            AlertView.instance.showAlert(title: "Download Error", message: error, alertType: .failure)
        }
        
        
        
        
        
        
    }
    
    
    private func selectedIndex(urlString: String, imageData:  @escaping (Data?) -> Void) {
        photoViewModel?.imageDownload(urlString: urlString, data: { [weak self] in
            self?.photoViewModel?.savePhotoDetails(data: $0)
            imageData($0)
        })
    }
    
}


@available(iOS 15.0, *)
extension PhotoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requestData?.count ?? requestPhotoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell
        guard let cell = cell else {
            return UICollectionViewCell()
        }
        selectedIndex(urlString: requestData?[indexPath.row].flickrImageURL() ?? "") {
            cell.addSubview(self.activityIndicator)
            self.activityIndicator.frame = cell.bounds
            self.activityIndicator.startAnimating()
            cell.photoImageView.load(data: $0 ?? self.requestPhotoList[indexPath.row])
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.5
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let urlString = requestData?[indexPath.row].flickrImageURL("b")  {
            selectedIndex(urlString: urlString) { [weak self] in
                guard let self = self  else {
                    return
                }
                
                let _ = StoryBoardsID.boardMain.requestNavigation(to: ViewControllerID.ImageViewController, from: self, requestData: $0)
            }
        }else {
            guard let data: Data = self.photoViewModel?.loadPhotoDetails() else {
                return
            }
            print(data)
            let _ = StoryBoardsID.boardMain.requestNavigation(to: ViewControllerID.ImageViewController, from: self, requestData: data)
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let reqphoto = requestPhoto, let requData = requestData else {
            return
        }
        if reqphoto.page <  reqphoto.pages && indexPath.row == requData.count - 1 {
            currentPage += 1
            self.isSearching = true
            photoViewModel?.searchPhoto(query: query, pageNo: "\(currentPage)", data: { [weak self] in
                self?.requestData! += $0.searchdata
                collectionView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
            })
        }
    }
    
    
    
}


// MARK: - Collection View Flow Layout Delegate
@available(iOS 15.0, *)
// MARK: UICollectionViewDelegateFlowLayout
extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        guard let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        self.collectionView?.collectionViewLayout = layout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView?.showsHorizontalScrollIndicator = false
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem + 21
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



// MARK: - Text Field Delegate
@available(iOS 15.0, *)
extension PhotoListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
              !text.isEmpty
        else { return true }
        isSearching = true
        // 1
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        query = text
        PersistenceService.context.delete(self.photoList)
        handleSearch(query: query)
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    
}
