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
                self.applySnapshot(animatingDifferences: false)
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
        setGameModel.changeMatchedCards()
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
        guard let set = setGameModel.getNextSet(maxNumberOfSets: 10) else { return }
        setGameModel.removeBlinkStatuses()
        self.setGameModel.setBlinkStatuses(at: set, newStatus: .match)
    }
    
    func cellClick(index: Int) {
        setGameModel.selectCard(at: index)
    }
    
    func getAttrTitle(for card: Card) -> NSAttributedString {
        
        let color = getColor(colorOption: card.optionA)
        let figure = getFigure(figureOption: card.optionB)
        let amount = getAmount(amountOption: card.optionC)
        let attributes = getShape(shapeOption: card.optionD, color: color)
        
        var string = String(repeating: figure + "\n", count: amount)
        string.removeLast()
        
        return NSAttributedString(string: String(string), attributes: attributes)
    }
}

extension MainViewModel {
    
    private func getDealCardButtonCondition() -> Bool {
        if setGameModel.matchedCards.count == 3 { return true }
        if setGameModel.cardsOnTable.count >= AppSettings.shared.maxNumberOfCardCells { return false }
        if setGameModel.deck.cards.isEmpty { return false }
        return true
    }
    
    private func getColor(colorOption: Card.CardOption) -> UIColor {
        switch colorOption {
        case .caseA: return .red
        case .caseB: return .blue
        case .caseC: return .green
        }
    }
    
    private func getFigure(figureOption: Card.CardOption) -> String {
        switch figureOption {
        case .caseA: return "▲"
        case .caseB: return "●"
        case .caseC: return "■"
        }
    }
    
    private func getAmount(amountOption: Card.CardOption) -> Int {
        switch amountOption {
        case .caseA: return 1
        case .caseB: return 2
        case .caseC: return 3
        }
    }
    
    private func getShape(shapeOption: Card.CardOption, color: UIColor) -> [NSAttributedString.Key : Any] {
        switch shapeOption {
        case .caseA:
            return [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.strokeWidth: -1
            ]
        case .caseB:
            return [
                
                NSAttributedString.Key.strikethroughColor: UIColor.magenta
                //NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.35),
                //NSAttributedString.Key.strokeWidth: -1
            ]
        case .caseC:
            return [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.strokeWidth: 15
            ]
        }
    }
}
