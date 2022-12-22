//
//  DatabaseManager.swift
//  SearchRepositories
//
//  Created by Азат Киракосян on 09.08.2021.
//

import Foundation
import RealmSwift

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    var safeRealm: Realm? {
        do {
            let realm = try Realm()
            return realm
        } catch {
            assertionFailure("Error")
        }
        return nil
    }
    
    private var place: Results<RepositoryObject>? {
        let object = safeRealm?.objects(RepositoryObject.self)
        return object
    }
    
    private init() {}
    
    func saveRepository(object: RepositoryObject) {
        do {
            try safeRealm?.write {
                safeRealm?.add(object)
            }
        } catch {
            assertionFailure("Error")
        }
    }
    
    func containsID(id: Int) -> Bool {
        let object = safeRealm?.objects(RepositoryObject.self)
        let result = object?.contains(where: {$0.id == id}) ?? false
        return result
    }
    
    func removeRepository(id: Int) {
        do {
            try safeRealm?.write {
                let place = RepositoryObject()
                place.id = id
                if let result = safeRealm?.objects(RepositoryObject.self).filter("id=%@",place.id) {
                    safeRealm?.delete(result)
                }
            }
        } catch {
            assertionFailure("Error")
        }
    }
}
