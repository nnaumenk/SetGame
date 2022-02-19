//
//  ShapeView.swift
//  SetGame
//
//  Created by Nazar on 2/17/22.
//

import UIKit

class ShapeView: UIView {
    
    enum ShapeType: Int {
        case triangle
        case square
        case circle
        case undefined
    }
    enum ShapeView: Int {
        case solid
        case outline
        case strip
        case undefined
    }
    enum ShapeColor: Int {
        case red
        case blue
        case green
        case undefined
    }
    
    var shapeType: ShapeType { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var shapeView: ShapeView { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var shapeAmount: Int { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var shapeColor: ShapeColor { didSet { setNeedsDisplay(); setNeedsLayout() } }

    private let boundMinOffset: CGFloat = 4
    private let itemOffset: CGFloat = 4
    
    init(shapeType: ShapeType.RawValue, shapeView: ShapeView.RawValue, shapeAmount: Int, shapeColor: ShapeColor.RawValue) {
        self.shapeType = ShapeType(rawValue: shapeType) ?? .undefined
        self.shapeView = ShapeView(rawValue: shapeView) ?? .undefined
        self.shapeAmount = shapeAmount + 1
        self.shapeColor = ShapeColor(rawValue: shapeColor) ?? .undefined
        
        super.init(frame: .zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let outlinedShapes = getOutlinedShapes() else { return }
        let inlinedShapes = getInlinedShapes(outlinedShapes: outlinedShapes) ?? UIBezierPath()
        
        let shapes = UIBezierPath()
        shapes.append(outlinedShapes)
        shapes.append(inlinedShapes)
        setShapeColor(shapePath: shapes)
    }
    
    private func getOutlinedShapes() -> UIBezierPath? {
        
        let shapeFunc: (CGPoint, CGFloat) -> UIBezierPath
        let shapePath = UIBezierPath()
        
        switch shapeType {
        case .triangle: shapeFunc = getTriangle
        case .square: shapeFunc = getSquare
        case .circle: shapeFunc = getCircle
        case .undefined: return nil
        }
        
        for shapeYPosition in shapeYPositions {
            let path = shapeFunc(CGPoint(x: center.x, y: shapeYPosition), shapeLineSize)
            shapePath.append(path)
        }
        
        return shapePath
    }
    
    private func getInlinedShapes(outlinedShapes: UIBezierPath) -> UIBezierPath? {
        let context = UIGraphicsGetCurrentContext()
        let shapeFunc: (CGPoint, CGFloat) -> UIBezierPath
        let shapePath = UIBezierPath()
        
        switch shapeView {
        case .solid: shapeFunc = getSolidInlinedShape
        case .strip: shapeFunc = getStripInlinedShape
        case .outline: return nil
        case .undefined: return nil
        }
        
        outlinedShapes.addClip()
        
        for shapeYPosition in shapeYPositions {
            let path = shapeFunc(CGPoint(x: center.x, y: shapeYPosition), shapeLineSize)
            outlinedShapes.append(path)
            shapePath.append(path)
        }
        
        return shapePath
    }
    
    private func setShapeColor(shapePath: UIBezierPath) {
        
        switch shapeColor {
        case .red:
            UIColor.red.setStroke()
        case .blue:
            UIColor.blue.setStroke()
        case .green:
            UIColor.green.setStroke()
        case .undefined:
            return
        }
        
        shapePath.stroke()
    }
}
    
// MARK: SIZE & POSITION VARS
    
extension ShapeView {
    
    private var shapeLineSize: CGFloat {
        (bounds.height * 2 - bounds.width - itemOffset * 2 - boundMinOffset * 2) / 5
    }
    private var shapeDiagSize: CGFloat {
        shapeLineSize * sqrt(2)
    }
    
    private var shapeStepSize: CGFloat {
        let shapeSpaceAmount = 8 // number of spaces between strip lines
        return shapeLineSize / CGFloat((Int(shapeLineSize) + shapeSpaceAmount) / shapeSpaceAmount + 1)
    }
    
    private var shapeYPositions: [CGFloat] {
        switch shapeAmount {
        case 1: return [
            bounds.midY,
        ]
        case 2: return [
            bounds.midY - itemOffset / 2 - shapeLineSize / 2,
            bounds.midY + itemOffset / 2 + shapeLineSize / 2,
        ]
        case 3: return [
            bounds.midY - shapeLineSize - itemOffset,
            bounds.midY,
            bounds.midY + shapeLineSize + itemOffset,
        ]

        default: return []
        }
    }
}

// MARK: OUTLINED SHAPE METHODS

extension ShapeView {
    
    private func getSquare(at: CGPoint, lineSize: CGFloat) -> UIBezierPath {
        return UIBezierPath(rect: CGRect(x: at.x - lineSize / 2, y: at.y - lineSize / 2, width: lineSize, height: lineSize))
    }
    private func getCircle(at: CGPoint, diameter: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: at, radius: diameter / 2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
    }
    
    private func getTriangle(at: CGPoint, lineSize: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: at.x, y: at.y - lineSize / 2))
        path.addLine(to: CGPoint(x: at.x + lineSize / 2, y: at.y + lineSize / 2))
        path.addLine(to: CGPoint(x: at.x - lineSize / 2, y: at.y + lineSize / 2))
        path.close()
        
        return path
    }
}

// MARK: INLINED SHAPE METHODS

extension ShapeView {
    
    private func getSolidInlinedShape(at: CGPoint, lineSize: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        
        let minX = at.x - lineSize / 2
        let minY = at.y - lineSize / 2
        let maxX = at.x + lineSize / 2
        
        for delta in stride(from: 0, through: lineSize, by: 1) {
            let x1 = minX
            let y1 = minY + delta
            let x2 = maxX
            let y2 = minY + delta
            
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x2, y: y2))
        }
        
        return path
    }
    
    private func getStripInlinedShape(at: CGPoint, lineSize: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        
        let minX = at.x - lineSize / 2
        let minY = at.y - lineSize / 2
        
        for delta in stride(from: 0, through: lineSize, by: shapeStepSize) {
            let x1 = minX
            let y1 = minY + delta
            let x2 = minX + delta
            let y2 = minY
            
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x2, y: y2))
            
            path.move(to: CGPoint(x: x1 + lineSize, y: y1))
            path.addLine(to: CGPoint(x: x2, y: y2 + lineSize))
        }
        
        return path
    }
}
