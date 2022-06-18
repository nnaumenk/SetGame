//
//  AppSettings.swift
//  SetGame
//
//  Created by Nazar on 2/11/22.
//

import Foundation
import UIKit

struct AppSettings {
    
    let maxNumberOfCardCells = 24
    
    let selectColor = UIColor.blue
    let matchColor = UIColor.green
    let mismatchColor = UIColor.red
    
    let selectScore = -1
    let showSetScore = -20
    let mismatchScore = -20
    let matchScore = 10
    
    let cardExpectedRatio = 1.4
    
    let cardAnimationEnabled = true
    
    static let shared = AppSettings()
    private init() {}
}
