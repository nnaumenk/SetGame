//
//  CardCollectionView.swift
//  SetGame
//
//  Created by Nazar on 1/31/22.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier = "CardCollectionViewCell"
    var clickAction: (() -> Void)?

//    var attrTitle: NSAttributedString? = nil {
//        didSet { attrTitleChanged() }
//    }
    
    var shapeView: UIView? = nil {
        didSet { oldValue?.removeFromSuperview(); shapeViewChanged() }
    }
    
    var blinkColor: UIColor? = nil {
        didSet { blinkColorChanged() }
    }
    
    var borderColor: UIColor? = nil {
        didSet { borderColorChanged() }
    }
    
    private lazy var cardButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 3
        button.backgroundColor = .gray
        
//        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//        button.titleLabel?.lineBreakMode = .byWordWrapping
//        button.titleLabel?.textAlignment = .center
        
        //button.imageView =
        
        button.addAction(for: .touchUpInside, { [unowned self] in
            self.clickAction?()
        })
        self.addSubview(button)
        return button
    }()
    
    private let animationLayer: CABasicAnimation = {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.toValue = UIColor.gray.cgColor
        animation.duration = 0.2
        animation.repeatCount = 10
        animation.autoreverses = true
        return animation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        cardButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cardButton)
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    private func borderColorChanged() {
        self.cardButton.layer.borderColor = self.borderColor?.cgColor
    }
    
    private func blinkColorChanged() {
        DispatchQueue.main.async { [unowned self] in
            self.cardButton.layer.removeAllAnimations()
        }
        guard let blinkColor = blinkColor else { return }
        animationLayer.fromValue = blinkColor.cgColor

        DispatchQueue.main.async { [unowned self] in
            self.cardButton.layer.add(self.animationLayer, forKey: "")
        }
    }
    
//    private func attrTitleChanged() {
//        self.cardButton.setAttributedTitle(attrTitle, for: .normal)
//    }
    
    private func shapeViewChanged() {
        guard let shapeView = shapeView else { return }
        self.cardButton.addSubview(shapeView)
        shapeView.translatesAutoresizingMaskIntoConstraints = false
        shapeView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        shapeView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        shapeView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        shapeView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    private func setupContraints() {
        
        let propertyDictionary = propertyDictionary
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cardButton]-0-|", options: [], metrics: nil, views: propertyDictionary))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[cardButton]-0-|", options: [], metrics: nil, views: propertyDictionary))
    }
}
