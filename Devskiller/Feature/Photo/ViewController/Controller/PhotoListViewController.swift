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
    let dataSource = PhotosViewDataSource()
    lazy var photoViewModel: PhotoViewModelProtocol = {
        let service = BaseServices()
        let route = PhotoRoute(service: service)
        let storage = BaseStorage()
        let repo = PhotoRepo(route: route, localStorage: storage)
        return  PhotoViewModel(photoRepo: repo, delegate: self, dataSource: dataSource)
    }()
    var activityIndicator: ActivityIndicator? = ActivityIndicator()
    private let itemsPerRow: CGFloat = 2
    private var currentPage: Int = 1
    var isSearching: Bool = false

    
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    var query: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView?.dataSource = self.dataSource
        self.dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.collectionView?.reloadData()
        }
        query = "dog"
        handleSearch(query: query!)
        
    }
    
    func handleSearch(query: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator?.start()
        photoViewModel.searchPhoto(query:query, pageNo: "\(currentPage)", data: {  _ in   })
        self.activityIndicator?.stop()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.collectionView.reloadData()
       
        
    }
    func errorHandler(error: String) {
        self.activityIndicator?.stop()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        guard let photodataLoad = dataSource.data.value.first?.first?.viewModel?.loadPhotoList() else  {
            return
        }
        if photodataLoad.isEmpty ||  !isSearching {
            AlertView.instance.showAlert(title: "Download Error", message: error, alertType: .failure)
        }
    }
    
}



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
    
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            PersistenceService.context.delete(PhotoDetail(context: PersistenceService.context))
            photoViewModel.presentProfile(indexPath) {  [weak self] in
                                    let _ = StoryBoardsID.boardMain.requestNavigation(to: ViewControllerID.ImageViewController, from: self, requestData: $0)
            }
        }
    
    
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            guard let reqphoto = dataSource.data.value.first?.first?.SearchResponse, let requData = dataSource.data.value.first?.first?.searchModel else {
                return
            }
            if reqphoto.page <  reqphoto.pages && indexPath.row == requData.count - 1 {
                currentPage += 1
                self.isSearching = true
                photoViewModel.searchInfiniteScrollingPhoto(query: query!, pageNo: "\(currentPage)") { _ in
                    
                }
            }
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




