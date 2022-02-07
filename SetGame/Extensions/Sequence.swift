//
//  Array.swift
//  SetGame
//
//  Created by Nazar on 1/30/22.
//

import Foundation

extension Sequence where Element == Card {
    func isSet() -> Bool {
        
        let optionA = self.map { $0.optionA }
        let optionB = self.map { $0.optionB }
        let optionC = self.map { $0.optionC }
        let optionD = self.map { $0.optionD }
        
        if (optionA == optionB && optionA == optionC && optionA == optionD) {
            return true
        }
        
        if (optionA == optionB || optionA == optionC || optionA == optionD || optionB == optionC || optionB == optionD || optionC == optionD) {
            return false
        }
        
        return true
    }
    
}

