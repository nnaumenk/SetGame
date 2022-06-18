//
//  CardCollectionView.swift
//  SetGame
//
//  Created by Nazar on 1/31/22.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier = "CardCollectionViewCell"
    
    var shapeView: ShapeView? { didSet { shapeViewChanged(oldValue) } }
    
    var blinkColor: UIColor? { didSet { blinkColorChanged() } }
    
    var borderColor: UIColor? { didSet { borderColorChanged() } }
    
    private lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        addSubview(view)
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    private func shapeViewChanged(_ oldValue: ShapeView?) {
        oldValue?.removeFromSuperview()
        guard let shapeView = shapeView else { return }
        view.addSubview(shapeView)
    }
    
    private func borderColorChanged() {
        shapeView?.layer.borderColor = self.borderColor?.cgColor
    }
    
    private func blinkColorChanged() {
        guard let shapeView = shapeView else { return }
        
        DispatchQueue.main.async {
            shapeView.layer.removeAllAnimations()
        }
        guard let blinkColor = blinkColor else { return }
        animationLayer.fromValue = blinkColor.cgColor

        DispatchQueue.main.async {
            shapeView.layer.add(self.animationLayer, forKey: "")
        }
    }
    
    private func setupContraints() {
        
        let propertyDictionary = propertyDictionary
        
        let constraints = [
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: propertyDictionary),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: propertyDictionary)
        ].flatMap { $0 }
        
        constraints.forEach { $0.isActive = true }
    }
}
