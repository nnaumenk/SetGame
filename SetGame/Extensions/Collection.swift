//
//  Collection.swift
//  SetGame
//
//  Created by Nazar on 2/4/22.
//

import Foundation

extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
