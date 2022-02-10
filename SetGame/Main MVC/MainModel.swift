//
//  MainModel.swift
//  SetGame
//
//  Created by Nazar on 1/30/22.
//

import Foundation
import Combine

class MainModel {
    
    let maxNumberOfCells = 24
    
   // private var lastSelectedIndices = [Int]()
    
    @Published var isDealCardButtonActive = true
    
    var isDealCardButtonActiveCondition: Bool {
        if deck.playCards.count + 4 > maxNumberOfCells { return false }
        if deck.deckCards.isEmpty { return false }
        return true
    }
    
    var anyCancellable = [AnyCancellable?]()
    @Published var deck = Deck(toShuffle: true)
    
    
    
    
    init() {
        self.deck = Deck(toShuffle: true)
        self.startGame()
    }
//    override init(frame: CGRect) {
//        super.init(frame: CGRect)
//
//        self.startGame()
//    }
    
    func startGame() {
        deck = Deck(toShuffle: true)
        let newCards = deck.drawFromDeck(numberOfCards: 12)
        deck.addCardsToTable(cards: newCards)
    }
    
    func dealButtonClick() {
        isDealCardButtonActive = isDealCardButtonActiveCondition
        
        if deck.selectedCards.count == 3 {
            if deck.selectedCards.areSet() {
                deck.changeMatchedCards()
                return
            }
        }
    
        //if deck.playCards.count + 3 > maxNumberOfCells { return }
        
        let newCards = deck.drawFromDeck(numberOfCards: 3)
        deck.addCardsToTable(cards: newCards)
    }
    
    func restartButtonClick() {
        isDealCardButtonActive = true
        
        startGame()
    }
    
    func showSetButton() {
        startGame()//
    }
    
    func cellClick(index: Int) {
        isDealCardButtonActive = isDealCardButtonActiveCondition
        
        print("index", index)
        //if no match deselect them and select current
        // if match replace match card with new 3 cards
        // if current cell was not replaced select it
        // if currentIndex contains
        print("\n1\n")
        cellClickStep1()
        
        //selecting of cell
        //you can deselect cell if you haven't already selected 3 cells
        print("\n2\n")
        cellClickStep2(index: index)
       
       
        //showing matching
        //if match activate deal button
        print("\n3\n")
        cellClickStep3()
    }
}

extension MainModel {
    
    private func cellClickStep1() {
        //if no match deselect them and select current
        // if match replace match card with new 3 cards
        // if current cell was not replaced select it
        if deck.selectedCards.count != 3 { return }
        
        if deck.selectedCards.areSet() {
            deck.changeMatchedCards()
        } else {
            deck.deselectAllCards()
        }
        
    }
    
    private func cellClickStep2(index: Int) {
        
        //selecting of cell
        //you can deselect cell if you haven't already selected 3 cells
        if deck.selectedCards.count < 3 {
            if let isSelected = deck.playCards[safe: index]?.isSelected, isSelected {
                print("deselect!")
                deck.deselectCard(index: index)
            } else { deck.selectCard(index: index) }
        }
    }
    
    private func cellClickStep3() {
        
        //showing matching
        //if match activate deal button
        if deck.selectedCards.count == 3 {
            if deck.selectedCards.areSet() {
                deck.matchSelectedCards()
                self.isDealCardButtonActive = true
            } else {
                deck.mismatchSelectedCards()
            }
        }
    }
    
}
