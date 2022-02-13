//
//  ArrayHashableElement.swift
//  SetGame
//
//  Created by Nazar on 2/8/22.
//

import Foundation

extension Collection where Element: Hashable {

    func hasDuplicates() -> Bool {
        let dups = Dictionary(grouping: self, by: {$0})
        return !dups.filter{ $1.count > 1}.isEmpty
    }

}
