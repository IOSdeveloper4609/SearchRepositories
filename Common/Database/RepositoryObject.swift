//
//  RepositoryObject.swift
//  SearchRepositories
//
//  Created by Азат Киракосян on 09.08.2021.
//

import Foundation
import RealmSwift

final class RepositoryObject: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String?
    @objc dynamic var detailed: String?
    @objc dynamic var userEmail: String?
    @objc dynamic var login: String = ""
    @objc dynamic var userName: String?
    @objc dynamic var imageUrlString: String?
    
    var urlToImage: URL? {
        if let imageUrlString = imageUrlString {
            return URL(string: imageUrlString)
        }
        
        return nil
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
