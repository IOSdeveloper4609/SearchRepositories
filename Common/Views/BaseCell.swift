//
//  BaseCell.swift
//  SearchRepositories
//
//  Created by Азат Киракосян on 09.08.2021.
//

import UIKit

class BaseCell: UITableViewCell {
    
    let textStyle = UIFont(name: "Copperplate", size: 19)
    
    lazy var nameRepository: UILabel = {
        let label = UILabel()
        label.font = textStyle
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    static var identifier: String {
        String(describing: type(of: self))
    }
    
}
