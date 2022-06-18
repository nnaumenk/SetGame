//
//  DeckModel.swift
//  SetGame
//
//  Created by Nazar on 1/30/22.
//

import Foundation

struct Deck {
    
    private(set) var cards: [Card] = []
    
    init(toShuffle: Bool = true) {
        setupDeck(toShuffle: toShuffle)
    }
    
    mutating func draw(numberOfCards: Int) -> [Card] {
        var newCards = cards.removeFirstN(numberOfCards)
        
        for index in newCards.indices {
            newCards[index].isFaceUp = true
        }
        return newCards
    }
    
    mutating private func setupDeck(toShuffle: Bool) {
        cards.removeAll()
        
        for optionA in Card.CardOption.all {
            for optionB in Card.CardOption.all {
                for optionC in Card.CardOption.all {
                    for optionD in Card.CardOption.all {
                        let newCard = Card(optionA: optionA, optionB: optionB, optionC: optionC, optionD: optionD)
                        cards.append(newCard)
                    }
                }
            }
        }
        if toShuffle { cards.shuffle() }
    }
}
