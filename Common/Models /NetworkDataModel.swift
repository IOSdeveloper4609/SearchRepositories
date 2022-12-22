//
//  NetworkDataModel.swift
//  SearchRepositories
//
//  Created by Азат Киракосян on 09.08.2021.
//

import Foundation

struct NetworkData: Decodable {
    let items: [Repository]
}

struct Repository: Decodable {
    let id: Int
    let name: String?
    let detailed: String?
    var owner: Owner
    var link: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case detailed = "description"
        case owner
        case link = "html_url"
    }
}

struct Owner: Decodable {
    let login: String
    var email: String?
    var name: String?
}

struct UserData: Codable {
    var email: String?
    var name: String?
    let urlImage: URL?
    
    enum CodingKeys: String, CodingKey {
        case email
        case name
        case urlImage = "avatar_url"
    }
}
