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
    
    var anyCancellable = [AnyCancellable?]()
    var deck: Deck!
    
    
    
    
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
        deck.drawFromDeck(numberOfCards: 12)
    }
    
    func dealButtonClick() {
        if deck.playCards.count + 3 > maxNumberOfCells { return }
        
        deck.drawFromDeck(numberOfCards: 3)
        if deck.playCards.count + 3 > maxNumberOfCells { isDealCardButtonActive = false }
    }
    
    func restartButtonClick() {
        isDealCardButtonActive = true
        
        startGame()
    }
    
    func showSetButton() {
        startGame()//
    }
    
    func cellClick(index: Int) {
        
        //selecting of cell
        //you can deselect cell if you haven't already selected 3 cells
        cellClickStepOne(index: index)
       
        //if no match deselect them and select current
        // if match replace match card with new 3 cards
        // if current cell was not replaced select it
        cellClickStepTwo(index: index)
        
        
        
        
        if deck.selectedCards.count == 3 {
            //check Match
            print("Check")
            
        }
        
        
        
        //deck.playCards[safe: index]?.select()
        //lastSelectedIndices.append(index)
    }
    
//    func cellDeselected(index: Int) {
//
//        deck.deselectCard(index: index)
//        if lastSelectedIndices.indices.contains(index) {
//            lastSelectedIndices.remove(at: index)
//        }
//
//        //deck.playCards.in
//
//    }
    
}

extension MainModel {
    
    private func cellClickStepOne(index: Int) {
        
        //selecting of cell
        //you can deselect cell if you haven't already selected 3 cells
        if deck.selectedCards.count < 3 {
            if let isSelected = deck.playCards[safe: index]?.isSelected, isSelected {
                deck.deselectCard(index: index)
            } else { deck.selectCard(index: index) }
        }
    }
    
    private func cellClickStepTwo(index: Int) {
        //if no match deselect them and select current
        // if match replace match card with new 3 cards
        // if current cell was not replaced select it
        if deck.selectedCards.count == 3 {
            
//            if self.deck.selectedCards.uni
//                self.deck
//            } else {
//                
//            }
            //if no match deselect them and select current
            // if match replace match card with new 3 cards
            // if current cell was not replaced select it
            print("")
        }
    }
    
}
