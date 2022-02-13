//
//  CardModel.swift
//  SetGame
//
//  Created by Nazar on 1/30/22.
//

import Foundation

struct Card: Hashable {
    enum CardOption: Int {
        case caseA
        case caseB
        case caseC
        
        static var all = [caseA, caseB, caseC]
    }
    
    enum CardStatus {
        case none
        case select
        case match
        case mismatch
    }
    
    private(set) var optionA: CardOption
    private(set) var optionB: CardOption
    private(set) var optionC: CardOption
    private(set) var optionD: CardOption

    var selectionStatus: CardStatus = .none
    var blinkStatus: CardStatus = .none {
        didSet { if blinkStatus == .match { blinkMatchCounter += 1 }}
    }
    private var blinkMatchCounter = 0
    
    
    init(optionA: CardOption, optionB: CardOption, optionC: CardOption, optionD: CardOption) {
        self.optionA = optionA
        self.optionB = optionB
        self.optionC = optionC
        self.optionD = optionD
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(optionA)
        hasher.combine(optionB)
        hasher.combine(optionC)
        hasher.combine(optionD)
    }
}
