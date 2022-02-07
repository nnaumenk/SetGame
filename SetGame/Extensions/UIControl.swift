//
//  UIControl.swift
//  SetGame
//
//  Created by Nazar on 2/4/22.
//

import UIKit

extension UIControl {
    
    func addAction(for controlEvents: UIControl.Event, _ closure: @escaping()->()) {
        addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
    }
    
}
