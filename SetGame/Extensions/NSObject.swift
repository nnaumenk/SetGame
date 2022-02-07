//
//  NSObject.swift
//  SetGame
//
//  Created by Nazar on 1/30/22.
//

import Foundation

extension NSObject {
    
    var propertyDictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)

        var objectDict: [String: Any] = [:]

        for child in mirror.children {
            guard let label = child.label else { continue }
            guard let key = label.components(separatedBy: "_").last else { continue }
            let value = child.value

            objectDict[key] = value
        }

        return objectDict
    }
    
    func getObjectDictionary<T: Any>() -> [String: T] {
        let mirror = Mirror(reflecting: self)
        
        var objectDict: [String: T] = [:]
        
        for child in mirror.children {
            guard let label = child.label else { continue }
            guard let key = label.components(separatedBy: "_").last else { continue }
            guard let value = child.value as? T else { continue }
            
            objectDict[key] = value
        }
        
        return objectDict
    }
    
    
}

