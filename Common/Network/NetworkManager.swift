//
//  NetworkManager.swift
//  SearchRepositories
//
//  Created by Азат Киракосян on 09.08.2021.
//

import Foundation


final class NetworkManager: Service {
    
    func getRepositories(page: Int, perPage: Int, value: String, completion: @escaping ([Repository]) -> Void) {
        let parameters = ["page": String(page),
                          "per_page": String(perPage),
                          "q": value,]

        let completion: (NetworkData?) -> Void = { data in
            guard let data = data else {
                print("Error")
                return completion([])
            }

            completion(data.items)
        }

        sendGetRequest(
            path: "/search/repositories",
            host: "api.github.com",
            parameters: parameters,
            completion: completion
        )
    }
    
    func getDataRepositories(by login: String,  completion: @escaping (UserData?) -> Void) {
        sendGetRequest(
            path: "/users/\(login)",
            host: "api.github.com",
            parameters: [:],
            completion: completion
        )
    }

}
