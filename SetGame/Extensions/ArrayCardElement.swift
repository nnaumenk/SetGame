//
//  ArrayCardElement.swift
//  SetGame
//
//  Created by Nazar on 2/8/22.
//

import Foundation

extension Array where Element == Card {
    
    func areSet() -> Bool {
        if (count != 3) { return false }
        
        let options = [
            self.map({ $0.optionA }),
            self.map({ $0.optionB }),
            self.map({ $0.optionC }),
            self.map({ $0.optionD }),
        ]
        
        for option in options {
            if (option.allSatisfy{ $0 == option.first }) { continue }
            if (option.hasDuplicates()) { return false }
        }
        return true
    }
    
//    extension Sequence where Element == Card {
//        func isSet() -> Bool {
//
//            let optionA = self.map { $0.optionA }
//            let optionB = self.map { $0.optionB }
//            let optionC = self.map { $0.optionC }
//            let optionD = self.map { $0.optionD }
//
//            if (optionA == optionB && optionA == optionC && optionA == optionD) {
//                return true
//            }
//
//            if (optionA == optionB || optionA == optionC || optionA == optionD || optionB == optionC || optionB == optionD || optionC == optionD) {
//                return false
//            }
//
//            return true
//        }
        
//    }
    
}
