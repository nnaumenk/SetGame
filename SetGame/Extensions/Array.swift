//
//  Array.swift
//  SetGame
//
//  Created by Nazar on 1/30/22.
//

import Foundation

extension Array {
    
    mutating func removeFirstN(_ numberOfElements: Int) -> [Element] {
        
        var newArray: [Element] = []

        let newIndex = Swift.min(numberOfElements, self.count)
        for _ in 0..<newIndex {
            newArray.append(self.removeFirst())
        }
        
        return newArray
    }
}
