//
//  FavouriteViewController.swift
//  SearchRepositories
//
//  Created by Азат Киракосян on 09.08.2021.
//

import UIKit

final class FavouriteViewController: UIViewController {
    
    private var favoritesArray = [RepositoryObject]()
    private var databaseManager = DatabaseManager.shared
     
    private lazy var mainTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        getObjectsFromTheDatabase()
    }
    
}

// MARK: - Private
extension FavouriteViewController {
    
    func setupUI() {
        navigationItem.title = "Избранное"
        navigationController?.navigationBar.prefersLargeTitles = false
        setupMainTableView()
    }

    func setupMainTableView() {
        view.addSubview(mainTableView)
        
        NSLayoutConstraint.activate([
            mainTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainTableView.topAnchor.constraint(equalTo: view.topAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func getObjectsFromTheDatabase() {
        guard let objects = databaseManager.safeRealm?.objects(RepositoryObject.self) else {
            return
        }
        
        favoritesArray.removeAll()
        
        for object in objects {
            favoritesArray.append(object)
        }
        
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }

}

// MARK: - UITableViewDataSource
extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.identifier, for: indexPath) as? FavoritesCell,
              let modelPlace = favoritesArray[safe: indexPath.row] else {
            assertionFailure("this cell is missing")
            return UITableViewCell()
        }
        cell.setupCell(with: modelPlace)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = self.favoritesArray[indexPath.row].id
            self.favoritesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            DatabaseManager.shared.removeRepository(id: object)
        }
    }
}
