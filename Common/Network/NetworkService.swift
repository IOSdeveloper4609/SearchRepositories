//
//  Service.swift
//  SearchRepositories
//
//  Created by Азат Киракосян on 09.08.2021.
//

import Foundation

class Service {
    
    func sendGetRequest<T: Decodable>(path: String, host: String, parameters: [String: String], completion: @escaping (T?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        if !parameters.isEmpty {
            urlComponents.queryItems = parameters.compactMap { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = urlComponents.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("user:email", forHTTPHeaderField: "X-Oauth-Scope")
        URLSession.shared.dataTask(with: request) { data,_,error in
            if let error = error {
                completion(nil)
                assertionFailure(error.localizedDescription)
            } else if let data = data, let results = self.parseResponse(T.self, data: data) {
                completion(results)
            }
        }.resume()
    }
    
    private func parseResponse<T>(_ type: T.Type, data: Data) -> T? where T: Decodable {
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print(error)
            return nil
        }
    }

}
