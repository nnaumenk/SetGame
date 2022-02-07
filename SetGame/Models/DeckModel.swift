//
//  DeckModel.swift
//  SetGame
//
//  Created by Nazar on 1/30/22.
//

import Foundation

struct Deck {
    
    private(set) var deckCards: [Card] = []
    private(set) var playCards: [Card] = []
    private(set) var selectedCards: [Card] = []
    
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
    
    mutating func drawFromDeck(numberOfCards: Int) {
        self.playCards += self.deckCards.removeFirstN(numberOfCards)
    }
    
    mutating func removeFromTable(selectedIndices: [Int]) {
        for index in selectedIndices {
            if self.playCards.indices.contains(index) {
                self.playCards.remove(at: index)
            }
        }
    }
    
    
    
    //mutating func c
    
    mutating func selectCard(index: Int) {
        
        print("Selected")
        if !self.playCards.indices.contains(index) { return }
        
        self.playCards[index].isSelected = true
        self.selectedCards.append(self.playCards[index])
    }
    
    mutating func deselectCard(index: Int) {
        print("Deselected")
        if !self.playCards.indices.contains(index) { return }
        print("OK1")
        
        
        guard let index = self.selectedCards.firstIndex(of: self.playCards[index]) else { return }
        
        
        print("OK2", self.selectedCards.count)
        self.selectedCards.remove(at: index)
        self.playCards[index].isSelected = false
        print("OK3", self.selectedCards.count)
    }
    
}
