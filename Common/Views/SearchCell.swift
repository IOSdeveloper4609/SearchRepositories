//
//  SearchCell.swift
//  SearchRepositories
//
//  Created by Азат Киракосян on 09.08.2021.
//

import UIKit

final class SearchCell: BaseCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setupWithModel(model: Repository) {
        nameRepository.text = model.name
    }
    
}

// MARK: - Private
private extension SearchCell {
    
    func setupUI() {
        setupNameRepository()
    }

    func setupNameRepository() {
        contentView.addSubview(nameRepository)

        NSLayoutConstraint.activate([
            nameRepository.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameRepository.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            nameRepository.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            nameRepository.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
