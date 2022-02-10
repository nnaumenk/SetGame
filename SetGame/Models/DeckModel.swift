//
//  DeckModel.swift
//  SetGame
//
//  Created by Nazar on 1/30/22.
//

import Foundation

struct Deck {
    
    var selectedCards: [Card] {
        self.playCards.filter { $0.isSelected == true }
    }
    
    private(set) var deckCards: [Card] = []
    private(set) var playCards: [Card] = []
    
    
    //private(set) var selectedCards: [Card] = []
    
    init(toShuffle: Bool) {
        
        for optionA in Card.CardOption.all {
            for optionB in Card.CardOption.all {
                for optionC in Card.CardOption.all {
                    for optionD in Card.CardOption.all {
                        let newCard = Card(optionA: optionA, optionB: optionB, optionC: optionC, optionD: optionD)
                        deckCards.append(newCard)
                    }
                }
            }
        }
        if toShuffle { deckCards.shuffle() }
        
    }
    
    mutating func drawFromDeck(numberOfCards: Int) -> [Card] {
        self.deckCards.removeFirstN(numberOfCards)
    }
    
    mutating func addCardsToTable(cards: [Card]) {
        self.playCards += cards
    }
    
//    mutating func removeCardsFromTable(selectedIndices: [Int]) {
//        for index in selectedIndices {
//            if self.playCards.indices.contains(index) {
//                self.playCards.remove(at: index)
//            }
//        }
//    }
    
    
    
    //mutating func c
    
    mutating func selectCard(index: Int) {
        
        print("Selected")
        if !self.playCards.indices.contains(index) { return }
        print("isSelected = true")
        self.playCards[index].isSelected = true
    }
    
    mutating func deselectCard(index: Int) {
        print("Deselected")
        if !self.playCards.indices.contains(index) { return }
        self.playCards[index].isSelected = false
        
        print("isSelected = false")
    }
    
    mutating func deselectAllCards() {
        for index in self.playCards.indices {
            self.playCards[index].isSelected = false
            self.playCards[index].isMatched = nil
        }
    }
    
    mutating func changeMatchedCards() {
        
        if self.deckCards.isEmpty {
            self.playCards = self.playCards.filter { !($0.isMatched ?? false) }
        } else {
            for index in self.playCards.indices {
                guard let isMatched = self.playCards[index].isMatched else { continue }
                guard isMatched else { continue }
                guard let newCard = self.drawFromDeck(numberOfCards: 1).first else { break }

                self.playCards[index] = newCard
            }
        }
        
    }
    
    mutating func matchSelectedCards() {
        for index in self.playCards.indices {
            if self.playCards[index].isSelected ?? false {
                self.playCards[index].isMatched = true
            }
        }
    }
    
    mutating func mismatchSelectedCards() {
        for index in self.playCards.indices {
            if self.playCards[index].isSelected ?? false {
                self.playCards[index].isMatched = false
            }
        }
    }
    
}
