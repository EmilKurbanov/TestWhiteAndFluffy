//
//  FavoriteCell.swift
//  TestWhiteAndFluffy
//
//  Created by emil kurbanov on 31.03.2025.
//

import UIKit
import Kingfisher

class FavoriteCell: UITableViewCell {
    private let photoImageView = UIImageView()
    private let nameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 12

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 18, weight: .medium)

        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            photoImageView.heightAnchor.constraint(equalToConstant: 100), 

            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with photo: PhotoInfoModel) {
        nameLabel.text = photo.username
        if let url = photo.photoURL {
            photoImageView.kf.setImage(with: url)
        }
    }
}
