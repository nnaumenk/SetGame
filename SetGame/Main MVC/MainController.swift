//
//  MainController.swift
//  SetGame
//
//  Created by Nazar on 1/30/22.
//

import UIKit
import Combine

final class MainController: UIViewController {
    
    private var mvcModel = MainModel()
    private var mvcView = MainView()
    
    private lazy var dataSource = makeDataSource()
    
    override func loadView() {
        self.view = mvcView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mvcModel.startGame()
        setupMVC()
        bindData()
        addActions()
        applySnapshot()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        mvcView.cardCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        
        mvcView.updateCardCellDimensions(numberOfCells: mvcModel.maxNumberOfCells)
          
        let HSpace = mvcView.cardCellDimensions.cellHorizontalSpacing
        let VSpace = mvcView.cardCellDimensions.cellVerticalSpacing
        
        mvcView.cardCollectionView.contentInset = UIEdgeInsets(top: VSpace, left: HSpace, bottom: VSpace, right: HSpace)
    }
    
    
    private func setupMVC() {
        
        mvcView.cardCollectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCollectionViewCell")
       
        mvcView.cardCollectionView.backgroundColor = .gray
        
        mvcView.cardCollectionView.delegate = self
    }
    
    private func bindData() {
        
        mvcModel.anyCancellable.append(mvcModel.$isDealCardButtonActive.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: mvcView.dealCardButton))
        
    }
    
    private func addActions() {
        
        mvcView.dealCardButton.addAction(for: .touchUpInside) { [weak self] in
            self?.mvcModel.dealButtonClick()
            self?.applySnapshot()
        }
        
        mvcView.restartButton.addAction(for: .touchUpInside) { [weak self] in
            self?.mvcModel.restartButtonClick()
            self?.applySnapshot(animatingDifferences: false)
        }
        
        mvcView.showSetButton.addAction(for: .touchUpInside) { [weak self] in
            self?.mvcModel.showSetButton()
            self?.applySnapshot()
        }
    }
        
}


extension MainController {
    
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
                NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.2),
                NSAttributedString.Key.strokeWidth: -1
            ]
        case .caseC:
            return [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.strokeWidth: 15
            ]
        }
    }
    
    private func getAttributedString(card: Card) -> NSAttributedString {
        let color = getColor(colorOption: card.optionA)
        let figure = getFigure(figureOption: card.optionB)
        let amount = getAmount(amountOption: card.optionC)
        let attributes = getShape(shapeOption: card.optionD, color: color)
        
        var string = String(repeating: figure + "\n", count: amount)
        string.removeLast()
        
        return NSAttributedString(string: String(string), attributes: attributes)
    }
    
    private func getCellBorderColorSelection(card: Card) -> CGColor? {
        if card.isSelected == false { return nil }
        
        guard let isMatched = card.isMatched else { return UIColor.blue.cgColor }
        
        if isMatched { return UIColor.green.cgColor }
        else { return UIColor.red.cgColor }
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Card> {
      // 1
        let dataSource = UICollectionViewDiffableDataSource<Section, Card>(collectionView: mvcView.cardCollectionView, cellProvider: { (collectionView, indexPath, card) -> UICollectionViewCell? in
          // 2
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell
            cell?.cardButton.setAttributedTitle(self.getAttributedString(card: card), for: .normal)
            cell?.cardButton.layer.borderColor = self.getCellBorderColorSelection(card: card)
            cell?.clickAction = { [weak self] in
                //print("CARD = \n", self?.mvcModel.deck.playCards[safe: indexPath.row])
                self?.mvcModel.cellClick(index: indexPath.row)
                self?.applySnapshot()
            }
            return cell
      })
      return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        // 2
        var snapshot = NSDiffableDataSourceSnapshot<Section, Card>()
        // 3
        snapshot.appendSections([.main])
        // 4
        snapshot.appendItems(mvcModel.deck.playCards)
        // 5
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension MainController: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        //print("cellHorizontalSpacing =", mvcView.cardCellDimensions.cellHorizontalSpacing)
        return mvcView.cardCellDimensions.cellHorizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        //print("cellVerticalSpacing =", mvcView.cardCellDimensions.cellVerticalSpacing)
        return mvcView.cardCellDimensions.cellVerticalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = mvcView.cardCellDimensions.cellWidth
        let height = mvcView.cardCellDimensions.cellHeight
        
        return CGSize(width: width, height: height)
    }
}



