//
//  Extention + Array.swift
//  SearchRepositories
//
//  Created by Азат Киракосян on 09.08.2021.
//

import Foundation

extension Array {
    
   subscript (safe index: Int) -> Element? {
       return indices.contains(index) ? self[index] : nil
   }
    
}
