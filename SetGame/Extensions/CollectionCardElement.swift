//
//  ArrayCardElement.swift
//  SetGame
//
//  Created by Nazar on 2/8/22.
//

import Foundation

extension Collection where Element == Card {
    
    func isSet() -> Bool {
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
}
