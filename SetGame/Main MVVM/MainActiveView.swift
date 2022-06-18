//
//  MainController.swift
//  SetGame
//
//  Created by Nazar on 1/30/22.
//

import UIKit
import Combine

final class MainActiveView: UIViewController {
    
    private var myViewModel = MainViewModel()
    private var myPassiveView = MainPassiveView()
    private var anyCancellable = Set<AnyCancellable>()
    
    override func loadView() {
        self.view = myPassiveView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindData()
        addActions()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        myPassiveView.cardCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        
        myPassiveView.updateCardCellDimensions(numberOfCells:  AppSettings.shared.maxNumberOfCardCells)
          
        let HSpace = myPassiveView.cardCellDimensions.cellHorizontalSpacing
        let VSpace = myPassiveView.cardCellDimensions.cellVerticalSpacing
        
        myPassiveView.cardCollectionView.contentInset = UIEdgeInsets(top: VSpace, left: HSpace, bottom: VSpace, right: HSpace)
        
        print("didlayout")
        //myViewModel.applySnapshot()
    }
    
    
    private func setupView() {
        myPassiveView.cardCollectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        myPassiveView.cardCollectionView.delegate = self
        
        myViewModel.diffableDataSource = CardCollectionViewDiffableDataSource(collectionView: myPassiveView.cardCollectionView) { (collectionView, indexPath, card) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
            
            cell.shapeView = ShapeView(shapeType: card.optionA.rawValue, shapeView: card.optionB.rawValue, shapeAmount: card.optionC.rawValue, shapeColor: card.optionD.rawValue)
            
            cell.shapeView?.launchFaceUpAnimation()
            
            switch card.selectionStatus {
            case .none: cell.borderColor = nil
            case .select: cell.borderColor = AppSettings.shared.selectColor
            case .match: cell.borderColor = AppSettings.shared.matchColor
            case .mismatch: cell.borderColor = AppSettings.shared.mismatchColor
            }
            
            switch card.blinkStatus {
            case .none, .select: cell.blinkColor = nil
            case .match: cell.blinkColor = AppSettings.shared.matchColor
            case .mismatch: cell.blinkColor = AppSettings.shared.mismatchColor
            }
            
            return cell
        }
    }
    
    private func bindData() {
        myViewModel.$isDealCardButtonActive
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: myPassiveView.dealCardButton)
            .store(in: &anyCancellable)
        
        myViewModel.$numberOfDeckCards
            .map { String($0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: myPassiveView.deckCountLabel)
            .store(in: &anyCancellable)
        
        myViewModel.$scorePoints
            .map { String($0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: myPassiveView.scoreCountLabel)
            .store(in: &anyCancellable)
    }
    
    private func addActions() {
        
        myPassiveView.dealCardButton.addAction(for: .touchUpInside) { [unowned self] in
            self.myViewModel.dealButtonClick()
        }
        
        myPassiveView.restartButton.addAction(for: .touchUpInside) { [unowned self] in
            self.myViewModel.restartButtonClick()
        }
        
        myPassiveView.showSetButton.addAction(for: .touchUpInside) { [unowned self] in
            self.myViewModel.showSetButtonClick()
        }
    }
}

extension MainActiveView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myViewModel.setGameModel.selectCard(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        myViewModel.setGameModel.selectCard(at: indexPath.row)
    }
    
}

extension MainActiveView: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return myPassiveView.cardCellDimensions.cellHorizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return myPassiveView.cardCellDimensions.cellVerticalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = myPassiveView.cardCellDimensions.cellWidth
        let height = myPassiveView.cardCellDimensions.cellHeight
        
        return CGSize(width: width, height: height)
    }
}



