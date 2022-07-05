//
//  ViewController.swift
//  Devskiller
//
//  Created by Ivo Silva on 18/09/2020.
//  Copyright © 2020 Mindera. All rights reserved.
//

import UIKit

class PhotoListViewController: BaseViewController, PhotoViewDelegateProtocol {
    
    let dataSource = PhotosViewDataSource()
    
    lazy var photoViewModel: PhotoViewModelProtocol = {
        return  PhotoViewModel(photoRepo:
                                PhotoRepo(route:
                                            PhotoRoute(service:
                                                        BaseServices()),
                                          localStorage: BaseStorage()),
                               delegate: self,
                               dataSource: dataSource)
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .natural
        textField.placeholder = "  search"
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.minimumFontSize = 17
        textField.backgroundColor = .systemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        collection.isPrefetchingEnabled = true
        collection.clipsToBounds = true
        collection.collectionViewLayout = createLayout()
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private var currentPage: Int = 1
    var isSearching: Bool = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView () {
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        navigationItem.title = "Home"
        NSLayoutConstraint.activate([
            searchTextField.heightAnchor.constraint(equalToConstant: 60),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.dataSource = self.dataSource
        collectionView.delegate = self
        self.dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.collectionView.reloadData()
        }
        view.backgroundColor = .tertiarySystemGroupedBackground
        setUpView()
        
        searchTextField.delegate = self
        photoViewModel.query = "dog"
        handleSearch(query: photoViewModel.query)
        
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6)
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3)), subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        
        // return UICollectionViewCompositionalLayout set
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func handleSearch(query: String) {
        photoViewModel.searchPhoto(query:query, pageNo: "\(currentPage)", data: {  _ in   })
        ActivityIndicator.shared.stop()
        self.collectionView.reloadData()
        
    }
    
    func errorHandler(error: String) {
        ActivityIndicator.shared.stop()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoViewModel.deletePhotoDetails()
        photoViewModel.presentProfile(indexPath) {  [weak self] in
            let _ = StoryBoardsID.boardMain.requestNavigation(to: ImageViewController(), from: self, requestData: $0, mode: .present)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let reqphoto = dataSource.data.value.first?.first?.SearchResponse, let requData = dataSource.data.value.first?.first?.searchModel else {
            return
        }
        if reqphoto.page <  reqphoto.pages && indexPath.row == requData.count - 1 {
            currentPage += 1
            self.isSearching = true
            ActivityIndicator.shared.start(view: cell)
            photoViewModel.searchInfiniteScrollingPhoto(query: photoViewModel.query, pageNo: "\(currentPage)") { _ in
                ActivityIndicator.shared.stop()
            }
        }
    }
    
}


