//
//  FavouriteCell.swift
//  SearchRepositories
//
//  Created by Азат Киракосян on 09.08.2021.
//

import UIKit

final class FavoritesCell: BaseCell {
    
    private lazy var repositoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = textStyle
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = textStyle
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    private lazy var userEmailabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = textStyle
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setupCell(with model: RepositoryObject) {
        
        if let name = model.name {
            nameRepository.text = "Repository name:  \(name)"
            nameRepository.textColor = .black
        } else {
            nameRepository.text = "Missing repository name"
            nameRepository.textColor = .red
        }
        
        if let detailed = model.detailed {
            repositoryDescriptionLabel.text = "Description:  \(detailed)"
            repositoryDescriptionLabel.textColor = .black
        } else {
            repositoryDescriptionLabel.text = "Missing repository description"
            repositoryDescriptionLabel.textColor = .red
        }
        
        if let userName = model.userName  {
            userNameLabel.text = "User name:  \(userName)"
            userNameLabel.textColor = .black
        } else {
            userNameLabel.text = "Missing user name"
            userNameLabel.textColor = .red
        }
        
        if let userEmail = model.userEmail {
            userEmailabel.text = "User email:  \(userEmail)"
            userEmailabel.textColor = .black
        } else {
            self.userEmailabel.text = "Missing user email"
            self.userEmailabel.textColor = .red
        }
    }
}

// MARK: - Private -
private extension FavoritesCell {
    
    func setupUI() {
        setupNameRepository()
        setupRepositoryDescriptionLabel()
        setupUserNameLabel()
        setupUserEmailLabel()
    }
    
    func setupNameRepository() {
        contentView.addSubview(nameRepository)
        
        contentView.addConstraints([
            nameRepository.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameRepository.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            nameRepository.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
        ])
    }
    
    func setupRepositoryDescriptionLabel() {
        contentView.addSubview(repositoryDescriptionLabel)
        
        NSLayoutConstraint.activate([
            repositoryDescriptionLabel.topAnchor.constraint(equalTo: nameRepository.bottomAnchor, constant: 15),
            repositoryDescriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            repositoryDescriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
        ])
    }
    
    func setupUserNameLabel() {
        contentView.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: repositoryDescriptionLabel.bottomAnchor, constant: 15),
            userNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            userNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
        ])
    }
    
    func setupUserEmailLabel() {
        contentView.addSubview(userEmailabel)
        
        NSLayoutConstraint.activate([
            userEmailabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 15),
            userEmailabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            userEmailabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            userEmailabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
