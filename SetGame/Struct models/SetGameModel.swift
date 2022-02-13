//
//  SetGameModel.swift
//  SetGame
//
//  Created by Nazar on 2/11/22.
//

import Foundation

struct SetGame {
    
    private(set) var deck: Deck!
    private(set) var cardsOnTable: [Card] = []
    private(set) var score = 100
    
    private var currentShowSetArray: [Set<Int>] = []
    private var currentShowSetIndex = 0
    
    var selectedCards: [Card] { self.cardsOnTable.filter { $0.selectionStatus != .none }}
    var matchedCards: [Card] { self.cardsOnTable.filter { $0.selectionStatus == .match }}
    var mismatchedCards: [Card] { self.cardsOnTable.filter { $0.selectionStatus == .mismatch }}
    
    
    init() {
        startNewGame()
    }
    
    mutating func startNewGame() {
        deck = Deck()
        cardsOnTable = deck.draw(numberOfCards: 12)
        score = 100
        currentShowSetArray.removeAll()
        currentShowSetIndex = 0
    }
    
    mutating func drawCardsOnTable(numberOfCards: Int) {
        self.cardsOnTable += deck.draw(numberOfCards: numberOfCards)
    }
        
    mutating func removeCardsFromTable(indices: Set<Int>) {
        for index in indices.sorted(by: >) {
            if self.cardsOnTable.indices.contains(index) {
                self.cardsOnTable.remove(at: index)
            }
        }
    }
    
    mutating func deselectAllCards() {
        for index in cardsOnTable.indices {
            cardsOnTable[index].selectionStatus = .none
        }
    }
        
    mutating func changeMatchedCards() {
        if self.deck.cards.isEmpty {
            self.cardsOnTable = self.cardsOnTable.filter { !($0.selectionStatus == .match) }
        } else {
            for index in self.cardsOnTable.indices {
                guard cardsOnTable[index].selectionStatus == .match else { continue }
                guard let newCard = deck.draw(numberOfCards: 1).first else { break }
                
                self.cardsOnTable[index] = newCard
            }
        }
    }
}

// MARK: SELECT METHODS

extension SetGame {
    
    mutating func selectCard(at index: Int) {
        score += AppSettings.shared.selectScore
        
        if matchedCards.count == 3 {
            matchAction(selectedIndex: index)
            return
        }
        if mismatchedCards.count == 3 {
            mismatchAction(selectedIndex: index)
            return
        }
        selectAction(selectedIndex: index)
        checkMatchAction()
    }
    
    private mutating func matchAction(selectedIndex: Int) {
        if let card = cardsOnTable[safe: selectedIndex], !matchedCards.contains(card) {
            setSelectionStatuses(at: [selectedIndex], newStatus: .select)
        }
        changeMatchedCards()
    }
    
    private mutating func mismatchAction(selectedIndex: Int) {
        removeBlinkStatuses()
        setSelectionStatuses(at: [selectedIndex], newStatus: .select)
        changeSelectionStatuses(from: .mismatch, to: .none)
    }
    
    private mutating func selectAction(selectedIndex: Int) {
        if (cardsOnTable[safe: selectedIndex]?.selectionStatus ?? .select) == .select {
            setSelectionStatuses(at: [selectedIndex], newStatus: .none)
        } else {
            setSelectionStatuses(at: [selectedIndex], newStatus: .select)
            setBlinkStatuses(at: [selectedIndex], newStatus: .none)
        }
    }

    private mutating func checkMatchAction() {
        guard selectedCards.count == 3 else { return }
        
        if selectedCards.isSet() {
            changeSelectionStatuses(from: .select, to: .match)
            setBlinkStatusesFromSelection()
            score += AppSettings.shared.matchScore
        } else {
            score += AppSettings.shared.mismatchScore
            changeSelectionStatuses(from: .select, to: .mismatch)
            setBlinkStatusesFromSelection()
        }
    }
}

// MARK: BLINK METHODS

extension SetGame {
    
    mutating func setBlinkStatuses(at indices: Set<Int>, newStatus: Card.CardStatus) {
        for index in indices {
            guard cardsOnTable.indices.contains(index) else { return }
            cardsOnTable[index].blinkStatus = newStatus
        }
    }
    
    mutating func removeBlinkStatuses() {
        for index in self.cardsOnTable.indices {
            cardsOnTable[index].blinkStatus = .none
        }
    }
    
    mutating func setBlinkStatusesFromSelection() {
        for index in self.cardsOnTable.indices {
            cardsOnTable[index].blinkStatus = cardsOnTable[index].selectionStatus
        }
    }
}

// MARK: CHANGE SELECTION METHODS

extension SetGame {
    
    mutating func changeSelectionStatuses(from: Card.CardStatus, to: Card.CardStatus) {
        for index in self.cardsOnTable.indices {
            guard cardsOnTable[index].selectionStatus == from else { continue }
            cardsOnTable[index].selectionStatus = to
        }
    }
    
    mutating func setSelectionStatuses(at indices: Set<Int>, newStatus: Card.CardStatus) {
        for index in indices {
            guard cardsOnTable.indices.contains(index) else { return }
            cardsOnTable[index].selectionStatus = newStatus
        }
    }
}

// MARK: FINDING SET METHODS

extension SetGame {
    
    mutating func getNextSet(maxNumberOfSets: Int) -> Set<Int>? {
        let setArray = findNCurrentSets(amount: maxNumberOfSets)
        
        if setArray != currentShowSetArray {
            currentShowSetArray = setArray
            currentShowSetIndex = 0
        } else {
            currentShowSetIndex += 1
            if currentShowSetArray.count <= currentShowSetIndex {
                currentShowSetIndex = 0
            }
        }
        
        if currentShowSetArray[safe: currentShowSetIndex] != nil {
            score += AppSettings.shared.showSetScore
        }
        
        return currentShowSetArray[safe: currentShowSetIndex]
    }
    
    private func findNCurrentSets(amount: Int) -> [Set<Int>] {
        var setArray = [Set<Int>]()
        
        for index1 in cardsOnTable.indices {
            for index2 in cardsOnTable.indices {
                for index3 in cardsOnTable.indices {
                    guard index2 > index1 else { continue }
                    guard index3 > index2 else { continue }
                    
                    let card1 = cardsOnTable[index1]
                    let card2 = cardsOnTable[index2]
                    let card3 = cardsOnTable[index3]
                    guard [card1, card2, card3].isSet() else { continue }
                    
                    setArray.append([index1, index2, index3])
                    if setArray.count == amount { return setArray }
                }
            }
        }
        return setArray
    }
}
