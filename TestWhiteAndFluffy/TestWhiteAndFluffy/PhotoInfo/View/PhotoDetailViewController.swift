//
//  PhotoDetailViewController.swift
//  TestWhiteAndFluffy
//
//  Created by emil kurbanov on 31.03.2025.
//

import UIKit
import Kingfisher

class PhotoDetailViewController: UIViewController {
    private let imageView = UIImageView()
    private let authorLabel = UILabel()
    private let dateLabel = UILabel()
    private let locationLabel = UILabel()
    private let downloadsLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    private var photo: PhotoInfoModel

    init(photo: PhotoInfoModel) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        [authorLabel, dateLabel, locationLabel, downloadsLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        favoriteButton.setTitle("Добавить в избранное", for: .normal)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),

            authorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            downloadsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            downloadsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            favoriteButton.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: 20),
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func updateUI() {
        if let url = photo.photoURL {
            imageView.kf.setImage(with: url)
        }
 
        authorLabel.text = "Автор: \(photo.username ?? "-")"
        dateLabel.text = "Дата: \(photo.creationDate ?? "-")"
        locationLabel.text = "Местоположение: \(photo.location ?? "-")"
        downloadsLabel.text = "Скачиваний: \(photo.downloadsCount ?? "-")"

        updateFavoriteButton()
    }

    private func updateFavoriteButton() {
        let isFavorite = FavoriteManager.shared.isFavorite(photo)
        let title = isFavorite ? "Удалить из избранного" : "Добавить в избранное"
        favoriteButton.setTitle(title, for: .normal)
    }

    @objc private func toggleFavorite() {
        let isNowFavorite = !FavoriteManager.shared.isFavorite(photo)
        if isNowFavorite {
            FavoriteManager.shared.add(photo)
        } else {
            FavoriteManager.shared.remove(photo)
        }
        updateFavoriteButton()

        let alert = UIAlertController(
            title: isNowFavorite ? "Добавлено в избранное" : "Удалено из избранного",
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}

