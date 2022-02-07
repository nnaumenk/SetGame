//
//  CardModel.swift
//  SetGame
//
//  Created by Nazar on 1/30/22.
//

import Foundation

struct Card: Hashable {
    enum CardOption {
        case caseA
        case caseB
        case caseC
        
        static var all = [caseA, caseB, caseC]
    }
    
    private(set) var optionA: CardOption
    private(set) var optionB: CardOption
    private(set) var optionC: CardOption
    private(set) var optionD: CardOption
    
    var isSelected = false
    var isMatched: Bool? = nil
    
    static func == (lhs: Card, rhs: Card) -> Bool {
            return
                lhs.optionA == rhs.optionA &&
                lhs.optionB == rhs.optionB &&
                lhs.optionC == rhs.optionC &&
                lhs.optionD == rhs.optionD
        }
    
//    static func isSet(lhs: Card, rhs: Card) -> Bool {
//        
//    }
}
