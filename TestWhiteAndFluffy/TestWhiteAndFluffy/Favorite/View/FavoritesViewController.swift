//
//  FavoritesViewController.swift
//  TestWhiteAndFluffy
//
//  Created by emil kurbanov on 31.03.2025.
//
import UIKit

class FavoritesViewController: UIViewController {
    private var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Избранное"
        view.backgroundColor = .white

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: "FavoriteCell")
        tableView.rowHeight = 120  

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteManager.shared.getFavorites().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let photo = FavoriteManager.shared.getFavorites()[indexPath.row]
        cell.configure(with: photo)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = FavoriteManager.shared.getFavorites()[indexPath.row]
        let detailVC = PhotoDetailViewController(photo: photo)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

