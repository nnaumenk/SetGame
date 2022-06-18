//
//  MainModel.swift
//  SetGame
//
//  Created by Nazar on 1/30/22.
//

import UIKit
import Combine

class CardCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<String?, Card> {}

final class MainViewModel {
    
    var diffableDataSource: CardCollectionViewDiffableDataSource!
    
    @Published var setGameModel = SetGame()
    @Published var isDealCardButtonActive = true
    @Published var numberOfDeckCards = 0
    @Published var scorePoints = 0
    
    private var anyCancellable = Set<AnyCancellable>()
    private var snapshot = NSDiffableDataSourceSnapshot<String?, Card>()
    
    init() {
        $setGameModel
            .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] value in
                self.numberOfDeckCards = self.setGameModel.deck.cards.count
                self.scorePoints = self.setGameModel.score
                self.isDealCardButtonActive = self.getDealCardButtonCondition()
                self.applySnapshot(animatingDifferences: true)
                print("apply")
            }
            .store(in: &anyCancellable)
        
        setGameModel.startNewGame()
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        snapshot.deleteAllItems()
        snapshot.appendSections([""])
        
        snapshot.appendItems(setGameModel.cardsOnTable)
        self.diffableDataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func dealButtonClick() {
        if setGameModel.matchedCards.count == 3 {
            setGameModel.changeMatchedCards()
        } else {
            setGameModel.drawCardsOnTable(numberOfCards: 3)
        }
    }
    
    func restartButtonClick() {
        setGameModel.startNewGame()
    }
    
    func showSetButtonClick() {
        if setGameModel.matchedCards.count == 3 {
            setGameModel.changeMatchedCards()
        }
        guard let set = setGameModel.getNextSet(maxNumberOfSets: 10) else { return }
        setGameModel.removeBlinkStatuses()
        self.setGameModel.setBlinkStatuses(at: set, newStatus: .match)
    }
    
    func cellClick(index: Int) {
        //setGameModel.selectCard(at: index)
        
        setGameModel.cardsOnTable[index].isFaceUp = !setGameModel.cardsOnTable[index].isFaceUp
    }
    
    private func getDealCardButtonCondition() -> Bool {
        if setGameModel.matchedCards.count == 3 { return true }
        if setGameModel.cardsOnTable.count >= AppSettings.shared.maxNumberOfCardCells { return false }
        if setGameModel.deck.cards.isEmpty { return false }
        return true
    }
}
