//
//  PhotosViewController.swift
//  TestWhiteAndFluffy
//
//  Created by emil kurbanov on 31.03.2025.
//

import UIKit
import Kingfisher



class PhotosViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var photos: [PhotoInfoModel] = []
    private var searchQuery: String = ""
    private var searchTask: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPhotos()
    }

    private func setupUI() {
        title = "Фото"
        view.backgroundColor = .white

        searchController.searchBar.placeholder = "Поиск фото"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 2 - 10, height: 200)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func fetchPhotos() {
        let networkService = NetworkService()
        
        if !searchQuery.isEmpty {
            networkService.setupRequest(query: searchQuery)
        } else {
            networkService.setupRequest(query: "random")
        }

        networkService.getRequest { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let infoArray):
                    self?.photos = infoArray.compactMap { info in
                        guard let urlString = info.urls?.regular, let url = URL(string: urlString) else { return nil }
                        return PhotoInfoModel(
                            id: info.id ?? "",
                            photoURL: url,
                            username: info.user?.username ?? DefaultValues.username.rawValue,
                            creationDate: info.createdAt ?? DefaultValues.creationDate.rawValue,
                            location: info.user?.location ?? DefaultValues.location.rawValue,
                            downloadsCount: "\(info.downloads ?? 0)"
                        )
                    }
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Ошибка загрузки фото: \(error)")
                }
            }
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.configure(with: photos[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = PhotoDetailViewController(photo: photos[indexPath.item])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


extension PhotosViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            if let query = searchController.searchBar.text, !query.isEmpty {
                self.searchQuery = query
            } else {
                self.searchQuery = ""
            }
            self.fetchPhotos()
        }
        
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task) 
    }
}


