//
//  DetailedViewController.swift
//  SearchRepositories
//
//  Created by Азат Киракосян on 09.08.2021.
//

import UIKit
import SDWebImage
import SafariServices

final class DetailedViewController: UIViewController, UIScrollViewDelegate {
    
    var repository: Repository
   
    init(repository: Repository) {
        self.repository = repository
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let textStyle = UIFont(name: "Copperplate", size: 20)
    private var networkManager = NetworkManager()
    private var databaseManager = DatabaseManager.shared
    private var networkMonitor = NetworkMonitor.shared
   
    private lazy var myScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        return containerView
    }()
    
    
    private lazy var nameRepositories: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = textStyle
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    private lazy var descriptionRepositories: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = textStyle
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    private lazy var nameUser: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = textStyle
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    private lazy var emailUser: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = textStyle
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    private lazy var avatarUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var openlinkButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 23
        button.clipsToBounds = true
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("перейти", for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(openLink), for: .touchUpInside)
       
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        if networkMonitor.isConnected {
            fetchUserData()
        } else {
            showAlert(message: "Для поиска репозиториев включите интернет")
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        if self.databaseManager.containsID(id: repository.id) {
            showRedHeart()
        } else {
            showWhiteHeart()
        }
    }
    
}

// MARK: - Private
private extension DetailedViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Описание"
        setupMyScrollView()
        setupConteinerView()
        setupAvatarImageView()
        setupNameRepositories()
        setupDescriptionRepositories()
        setupNameUser()
        setupEmailUser()
        fetchUserData()
        setupLinkButton()
    }
    
    func fetchUserData() {
        let login = repository.owner.login
        
        networkManager.getDataRepositories(by: login) { [weak  self] results in
            guard let self = self else {
                return
            }
            
            self.repository.owner.email = results?.email
            self.repository.owner.name = results?.name
            
            DispatchQueue.main.async {
                self.avatarUserImageView.sd_setImage(with: results?.urlImage, placeholderImage: #imageLiteral(resourceName: "image"))
                
                if let name = self.repository.name {
                    self.nameRepositories.text = "Repository name: \(name)"
                } else {
                    self.nameRepositories.text = "Missing repository name"
                    self.nameRepositories.textColor = .red
                }
                
                if let detailed = self.repository.detailed {
                    self.descriptionRepositories.text = "Description: \(detailed)"
                } else {
                    self.descriptionRepositories.text = "Missing repository description"
                    self.descriptionRepositories.textColor = .red
                }
                
                if let userName = self.repository.owner.name {
                    self.nameUser.text = "User name: \(userName)"
                } else {
                    self.nameUser.text = "Missing user name"
                    self.nameUser.textColor = .red
                }
                
                if let userEmail = self.repository.owner.email {
                    self.emailUser.text = "User email: \(userEmail)"
                } else {
                    self.emailUser.text = "Missing email user"
                    self.emailUser.textColor = .red
                }
                
                if self.databaseManager.containsID(id: self.repository.id) {
                    self.showRedHeart()
                } else {
                    self.showWhiteHeart()
                }
            }
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupMyScrollView() {
        view.addSubview(myScrollView)
    
        NSLayoutConstraint.activate([
            myScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            myScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            myScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            myScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupConteinerView() {
        myScrollView.addSubview(containerView)
    
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: myScrollView.leftAnchor),
            containerView.topAnchor.constraint(equalTo: myScrollView.topAnchor),
            containerView.rightAnchor.constraint(equalTo: myScrollView.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: myScrollView.bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: myScrollView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: myScrollView.centerYAnchor)
        ])
    }
    
    func setupAvatarImageView() {
        containerView.addSubview(avatarUserImageView)
        
        NSLayoutConstraint.activate([
            avatarUserImageView.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 50),
            avatarUserImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            avatarUserImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -70),
            avatarUserImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func setupNameRepositories() {
        containerView.addSubview(nameRepositories)
        
        NSLayoutConstraint.activate([
            nameRepositories.topAnchor.constraint(equalTo: avatarUserImageView.bottomAnchor, constant: 25),
            nameRepositories.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            nameRepositories.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -35),
        ])
    }
    
    func setupDescriptionRepositories() {
        containerView.addSubview(descriptionRepositories)
        
        NSLayoutConstraint.activate([
            descriptionRepositories.topAnchor.constraint(equalTo: nameRepositories.bottomAnchor, constant: 25),
            descriptionRepositories.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            descriptionRepositories.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -35),
        ])
    }
    
    func setupNameUser() {
        containerView.addSubview(nameUser)
        
        NSLayoutConstraint.activate([
            nameUser.topAnchor.constraint(equalTo: descriptionRepositories.bottomAnchor, constant: 25),
            nameUser.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            nameUser.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -35),
        ])
    }
    
    func setupEmailUser() {
        containerView.addSubview(emailUser)
        
        NSLayoutConstraint.activate([
            emailUser.topAnchor.constraint(equalTo: nameUser.bottomAnchor, constant: 25),
            emailUser.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30),
            emailUser.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -35),
        ])
    }
    
    func setupLinkButton() {
        containerView.addSubview(openlinkButton)
        
        NSLayoutConstraint.activate([
            openlinkButton.topAnchor.constraint(equalTo: emailUser.bottomAnchor, constant: 65),
            openlinkButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 90),
            openlinkButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -90),
            openlinkButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    func showWhiteHeart() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "like"), style: .done, target: self, action: #selector(addToFavorites))
    }
    
    func showRedHeart() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "redHeart"), style: .done, target: self, action: #selector(addToFavorites))
    }
}

// MARK: - Actions
private extension DetailedViewController {
    @objc func addToFavorites() {
        if databaseManager.containsID(id: repository.id) {
            showWhiteHeart()
            databaseManager.removeRepository(id: repository.id)
        } else {
            showRedHeart()
            let repositoryObject = RepositoryObject()
            repositoryObject.id = repository.id
            repositoryObject.userEmail = repository.owner.email
            repositoryObject.name = repository.name
            repositoryObject.detailed = repository.detailed
            repositoryObject.userName = repository.owner.name
            databaseManager.saveRepository(object: repositoryObject)
        }
    }
    
    @objc func openLink() {
        if let url = URL(string: repository.link) {
            let result = SFSafariViewController(url: url)
            present(result, animated: true, completion: nil)
        }
    }
    
}
