//
//  ViewController.swift
//  SearchRepositories
//
//  Created by Азат Киракосян on 09.08.2021.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private var searchResultsArray = [Repository]()
    private var networkManager = NetworkManager()
    private var networkMonitor = NetworkMonitor.shared
    private var isLoading = false
    private let spinner = UIActivityIndicatorView()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .black
        
        return activityIndicator
    }()
    
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .search
        
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if !networkMonitor.isConnected {
            showAlert(Message: "Для поиска репозиториев включите интернет")
        }
    }

}

// MARK: - Private
private extension SearchViewController {
    
    func setupUI() {
        navigationItem.searchController = searchController
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Поиск"
        setupMainTableView()
        setupLayoutActivityIndicator()
    }
        
    func setupMainTableView() {
        view.addSubview(mainTableView)
        
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.topAnchor,constant: 70),
            mainTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupLayoutActivityIndicator() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    
    func openDetailedScreen(index: Int) {
        guard let model = searchResultsArray[safe: index] else {
            return
        }
        let detailViewController = DetailedViewController(repository: model)
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    func showAlert(Message: String){
        let alert = UIAlertController(title: "Ошибка",
                                      message: Message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func fetchRepositories() {
        if isLoading {
            return
        }
        
        isLoading = true
        
        let searchValue = searchController.searchBar.text?.lowercased() ?? ""
        let perPage = 15
        let page = searchResultsArray.count / perPage + 1
            
        networkManager.getRepositories(page: page,
                                       perPage: perPage,
                                       value: searchValue) { [weak self] results in
            self?.searchResultsArray.append(contentsOf: results)
            
            DispatchQueue.main.async  {
                self?.mainTableView.tableFooterView = self?.hideSpinnerFooter()
                self?.mainTableView.isUserInteractionEnabled = true
                self?.mainTableView.alpha = 1
                self?.stopActivityIndicator()
                self?.mainTableView.reloadData()
                self?.isLoading = false
            }
        }
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func startActivityIndicator() {
        mainTableView.isUserInteractionEnabled = false
        mainTableView.alpha = 0.2
        activityIndicator.startAnimating()
    }
    
    func setupSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        spinner.backgroundColor = .black
        spinner.startAnimating()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        return footerView
    }
    
    func hideSpinnerFooter() -> UIView {
        spinner.stopAnimating()
        return spinner
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController:  UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else {
            assertionFailure("this cell is missing")
            return UITableViewCell()
        }
        
        guard let model = searchResultsArray[safe: indexPath.row] else {
            assertionFailure("missing index outside the range")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.setupWithModel(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultsArray.removeAll()
        startActivityIndicator()
        fetchRepositories()
    }
    
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetailedScreen(index: indexPath.row)
    }
    
}

// MARK: - UIScrollViewDelegate
extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !searchResultsArray.isEmpty else {
            return
        }
        
        let position = scrollView.contentOffset.y
        if position > self.mainTableView.contentSize.height - scrollView.frame.size.height {
            mainTableView.tableFooterView = setupSpinnerFooter()
            fetchRepositories()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        stopActivityIndicator()
    }
    
}
