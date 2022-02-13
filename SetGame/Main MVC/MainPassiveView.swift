//
//  MainView.swift
//  SetGame
//
//  Created by Nazar on 1/30/22.
//

import UIKit

final class MainPassiveView: UIView {
    
    struct CardCollectionViewDimensions {
        var cellWidth: Double = 40
        var cellHeight: Double = 56
        var cellHorizontalSpacing: Double = 16
        var cellVerticalSpacing: Double = 16
    }
    
    private(set) var cardCellDimensions = CardCollectionViewDimensions()
    
    private(set) lazy var deckCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        return label
    }()
    
    private(set) lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        return label
    }()
    
    private(set) lazy var showSetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        
        button.setTitle("SHOW SET", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray
        return button
    }()
    
    private(set) lazy var dealCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        
        button.setTitle("DRAW CARDS", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray
        return button
    }()
    
    private(set) lazy var restartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        
        button.setTitle("RESTART", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray
        return button
    }()
    
    private(set) lazy var cardCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
        
        collectionView.backgroundColor = .gray
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContraints() {
        
        let propertyDictionary = [
            "cardCollectionView": self.cardCollectionView,
            "restartButton" : self.restartButton,
            "showSetButton" : self.showSetButton,
            "dealCardButton" : self.dealCardButton,
            "scoreLabel" : self.scoreLabel,
            "deckCountLabel" : self.deckCountLabel
        ]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[deckCountLabel]-0-[cardCollectionView]-0-[dealCardButton]-|", options: [], metrics: nil, views: propertyDictionary))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[scoreLabel]-0-[cardCollectionView]", options: [], metrics: nil, views: propertyDictionary))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[cardCollectionView]-0-[showSetButton]-|", options: [], metrics: nil, views: propertyDictionary))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[cardCollectionView]-0-[restartButton]-|", options: [], metrics: nil, views: propertyDictionary))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[deckCountLabel]-[scoreLabel]-|", options: [], metrics: nil, views: propertyDictionary))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[cardCollectionView]-0-|", options: [], metrics: nil, views: propertyDictionary))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[showSetButton]-[dealCardButton]-[restartButton]-|", options: [], metrics: nil, views: propertyDictionary))
        
        showSetButton.widthAnchor.constraint(equalTo: dealCardButton.widthAnchor, multiplier: 1.0).isActive = true
        showSetButton.widthAnchor.constraint(equalTo: restartButton.widthAnchor, multiplier: 1.0).isActive = true
    }
}

extension MainPassiveView {

    func updateCardCellDimensions(numberOfCells: Int) {
        let minimumSpace: Double = 16
        let width = self.cardCollectionView.frame.width
        let height = self.cardCollectionView.frame.height
        let ratio = width > height ? width / height : height / width
        let expectedCardRatio = 1.4
        let rowNumber: Double
        let columnNumber: Double
        
        if (height > width) {
            rowNumber = 6//ratio >= 1.4 ? 6 : 5
        } else {
            rowNumber = ratio >= 1.4 ? 3 : 4
        }
        columnNumber = ceil(Double(numberOfCells) / rowNumber)
        
        let cellMaxWidth = (width - ((columnNumber + 1) * minimumSpace)) / columnNumber
        let cellMaxHeight = (height - ((rowNumber + 1) * minimumSpace)) / rowNumber
        let realCardRatio = cellMaxHeight / cellMaxWidth
        let cellWidth: Double
        let cellHeight: Double
        
        if realCardRatio > expectedCardRatio {
            cellWidth = cellMaxWidth
            cellHeight = cellMaxWidth * expectedCardRatio
        } else {
            cellWidth = cellMaxHeight / expectedCardRatio
            cellHeight = cellMaxHeight
        }
        
        let cellVerticalSpacing = (height - (rowNumber * cellHeight)) / (rowNumber + 1)
        let cellHorizontalSpacing = (width - (columnNumber * cellWidth)) / (columnNumber + 1)
        
        self.cardCellDimensions = CardCollectionViewDimensions(cellWidth: cellWidth, cellHeight: cellHeight, cellHorizontalSpacing: cellHorizontalSpacing, cellVerticalSpacing: cellVerticalSpacing)
    }
    
}
