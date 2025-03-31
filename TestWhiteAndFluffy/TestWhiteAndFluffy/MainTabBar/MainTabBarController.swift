//
//  MainTabBarController.swift
//  TestWhiteAndFluffy
//
//  Created by emil kurbanov on 31.03.2025.
//


import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let photosVC = PhotosViewController()
        photosVC.tabBarItem = UITabBarItem(title: "Фото", image: UIImage(systemName: "photo.on.rectangle"), tag: 0)

        let favoritesVC = FavoritesViewController()
        favoritesVC.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(systemName: "heart"), tag: 1)

        viewControllers = [UINavigationController(rootViewController: photosVC),
                           UINavigationController(rootViewController: favoritesVC)]
    }
}
