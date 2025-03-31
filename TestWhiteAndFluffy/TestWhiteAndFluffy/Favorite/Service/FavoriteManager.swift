//
//  FavoriteManager.swift
//  TestWhiteAndFluffy
//
//  Created by emil kurbanov on 31.03.2025.
//

import Foundation

final class FavoriteManager {
    static let shared = FavoriteManager()
    private let key = "favoritePhotos"

    private init() {}

    func add(_ photo: PhotoInfoModel) {
        var favorites = getFavorites()
        if !favorites.contains(where: { $0.id == photo.id }) {
            favorites.append(photo)
            save(favorites)
        }
    }

    func remove(_ photo: PhotoInfoModel) {
        let favorites = getFavorites().filter { $0.id != photo.id }
        save(favorites)
    }

    func isFavorite(_ photo: PhotoInfoModel) -> Bool {
        return getFavorites().contains(where: { $0.id == photo.id })
    }

    func getFavorites() -> [PhotoInfoModel] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([PhotoInfoModel].self, from: data)) ?? []
    }

    private func save(_ favorites: [PhotoInfoModel]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(favorites) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
