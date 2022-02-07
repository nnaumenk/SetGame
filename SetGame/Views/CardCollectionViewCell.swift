//
//  CardCollectionView.swift
//  SetGame
//
//  Created by Nazar on 1/31/22.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    var clickAction: (() -> Void)?
    
    private(set) lazy var cardButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 3
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.gray.cgColor
        
       // button.titleLabel?.isHidden = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        
        button.addAction(for: .touchUpInside, { [weak self] in
            self?.clickAction?()
        })
        
        self.addSubview(button)
        return button
    }()
    
    convenience init(image: UIImage?) {
        self.init(frame: .zero)
        
        
        //self.cardButton.setImage(image, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = .white
        
        cardButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cardButton)
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        print("prepareForReuse =")
        
       // self.cardButton.titleLabel?.isHidden = true
        self.cardButton.setAttributedTitle(nil, for: .normal)
        self.clickAction = nil
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        self.cardButton.setAttributedTitle(nil, for: .normal)
        self.cardButton.layer.borderColor = nil
    }
    
    private func setupContraints() {
        
        let propertyDictionary = propertyDictionary
        
        print("1", propertyDictionary)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cardButton]-0-|", options: [], metrics: nil, views: propertyDictionary))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[cardButton]-0-|", options: [], metrics: nil, views: propertyDictionary))
        
        print(propertyDictionary)
    }
}
