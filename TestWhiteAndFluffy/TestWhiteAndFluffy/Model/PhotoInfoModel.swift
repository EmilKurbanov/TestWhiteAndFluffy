//
//  PhotoInfoModel.swift
//  TestWhiteAndFluffy
//
//  Created by emil kurbanov on 31.03.2025.
//

import Foundation

struct PhotoInfoModel: Codable {
    let id: String
    let photoURL: URL?
    let username: String?
    let creationDate: String?
    let location: String?
    let downloadsCount: String?
    var isLiked: Bool

    init(id: String, photoURL: URL?, username: String? = nil, creationDate: String? = nil, location: String? = nil, downloadsCount: String? = nil, isLiked: Bool = false) {
        self.id = id
        self.photoURL = photoURL
        self.username = username
        self.creationDate = creationDate
        self.location = location
        self.downloadsCount = downloadsCount
        self.isLiked = isLiked
    }
}

enum DefaultValues: String {
    case username = "User"
    case creationDate = "1970-01-01"
    case location = "Unknown location"
    case downloadsCount = "0"
}
