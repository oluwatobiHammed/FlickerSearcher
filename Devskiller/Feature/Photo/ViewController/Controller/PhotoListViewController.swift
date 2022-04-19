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
    private var requestData: [SearchPhotoViewModel] = []
    private var requestPhoto: PhotosResponse?
    private var currentPage: Int = 1
    private let photoList = PhotoList(context: PersistenceService.context)
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    private var query: String = ""
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let indexPath = IndexPath(row: requestData.count, section: 0)
//        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
//        collectionView.reloadData()
    }
    func errorHandler(error: String) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        AlertView.instance.showAlert(title: "Download Error", message: error, alertType: .failure)
        
        
        
    }
    
   private func selectedIndex(urlString: String, imageData:  @escaping (Data) -> Void) {
        photoViewModel?.imageDownload(urlString: urlString, data: { [weak self] in
            self?.photoViewModel?.savePhotoList(data: $0)
            imageData($0)
        })
    }
}


@available(iOS 15.0, *)
extension PhotoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requestData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell
        guard let cell = cell else {
            return UICollectionViewCell()
        }
        selectedIndex(urlString: requestData[indexPath.row].flickrImageURL() ?? "") {
            cell.addSubview(self.activityIndicator)
            self.activityIndicator.frame = cell.bounds
            self.activityIndicator.startAnimating()
            cell.photoImageView.load(data: $0)
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.5
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let urlString = requestData[indexPath.row].flickrImageURL("b") else {
            return
        }
        selectedIndex(urlString: urlString) { [weak self] in
            self?.photoViewModel?.savePhotoDetails(data: $0)
            let _ = StoryBoardsID.boardMain.requestNavigation(to: ViewControllerID.ImageViewController, from: self, requestData: $0)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
        if requestPhoto!.page <  requestPhoto!.pages && indexPath.row == requestData.count - 1 {
            currentPage += 1
            photoViewModel?.searchPhoto(query: query, pageNo: "\(currentPage)", data: { [weak self] in
                self?.requestData = $0.searchdata
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
        
        // 1
        
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        query = text
        
        photoViewModel?.searchPhoto(query: text, pageNo: "\(currentPage)", data: { [weak self] in
            PersistenceService.context.delete(self!.photoList)
            self?.requestData = $0.searchdata
            self?.requestPhoto = $0.SearchResponse
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.removeFromSuperview()
            self?.collectionView.reloadData()
            
        })
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    
}
