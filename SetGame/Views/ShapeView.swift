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
        
        //drawSquare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {

//        guard var shapePaths = getShapes() else { return }
//        guard shapePaths = setShapeView(shapePaths: shapePaths) else { return }
//        guard shapePaths = setShapeColor(shapePaths: shapePaths) else { return }
        
        guard let shapePaths = getShapes() else { return }
        setShapeView(shapePaths: shapePaths)
        setShapeColor(shapePaths: shapePaths)
        
    }
    
    private func getShapes() -> [UIBezierPath]? {
        
        let shapeFunc: (CGPoint, CGFloat) -> UIBezierPath
        var shapePaths: [UIBezierPath] = []
        
        switch shapeType {
        case .triangle: shapeFunc = getTriangle
        case .square: shapeFunc = getSquare
        case .circle: shapeFunc = getCircle
        case .undefined: return nil
        }
        
        for shapeYPosition in shapeYPositions {
            let path = shapeFunc(CGPoint(x: center.x, y: shapeYPosition), shapeLineSize)
            shapePaths.append(path)
        }
        return shapePaths
    }
    
    private func setShapeView(shapePaths: [UIBezierPath]) {
        switch shapeView {
        case .solid: addSolidShape(shapePaths: shapePaths)
        case .strip: addStripShape(shapePaths: shapePaths)
        case .outline: return
        case .undefined: return
        }
    }
    
    private func setShapeColor(shapePaths: [UIBezierPath]) {
        
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
        
        for i in shapePaths.indices {
            shapePaths[i].stroke()
        }
    }
}


extension ShapeView {
    
    private func addSolidShape(shapePaths: [UIBezierPath]) {
        let context = UIGraphicsGetCurrentContext()
        
        for path in shapePaths {
            //context?.saveGState()
            path.addClip()
            for delta in stride(from: 0, to: shapeLineSize, by: 1) {
                let x1 = path.bounds.minX
                let y1 = path.bounds.minY + delta
                let x2 = path.bounds.maxX
                let y2 = path.bounds.minY + delta
                
                path.move(to: CGPoint(x: x1, y: y1))
                path.addLine(to: CGPoint(x: x2, y: y2))
            }
        }
    }
    
    //private func addOutlineShape()
    
    private func addStripShape(shapePaths: [UIBezierPath]) {
        let context = UIGraphicsGetCurrentContext()
        
        //shapePaths.forEach( { $0.addClip() } )
        
        for path in shapePaths {
           // context?.saveGState()
           // path.addClip()
            
            for delta in stride(from: 0, through: shapeLineSize, by: shapeStepSize) {
                let x1 = path.bounds.minX
                let y1 = path.bounds.minY + delta
                let x2 = path.bounds.minX + delta
                let y2 = path.bounds.minY
                
                let bezier = UIBezierPath()
                //path.lineWidth = 1
                
                bezier.move(to: CGPoint(x: x1, y: y1))
                bezier.addLine(to: CGPoint(x: x2, y: y2))
                
                bezier.move(to: CGPoint(x: x1 + shapeLineSize, y: y1))
                bezier.addLine(to: CGPoint(x: x2, y: y2 + shapeLineSize))
                UIColor.yellow.setStroke()
                bezier.stroke()
                //context?.restoreGState()
            }
            //context?.restoreGState()
        }
    }
    
    
            //path.
            //path.addClip()
           // shapeMaxSize
            
//            for y in stride(from: path.bounds.minY + 3, to: path.bounds.maxY - 3, by: 3) {
//                bezier.move(to: CGPoint(x: path.bounds.minX, y: y))
//                bezier.addLine(to: CGPoint(x: path.bounds.maxX, y: y))
//                //bezier.
//                UIColor.yellow.setStroke()
//                bezier.stroke()
//
//            }
//
//            func rotate(path: UIBezierPath, degree: CGFloat) {
//                let bounds: CGRect = path.cgPath.boundingBox
//                let center = CGPoint(x: bounds.midX, y: bounds.midY)
//
//                let radians = degree / 180.0 * .pi
//                var transform: CGAffineTransform = .identity
//                transform = transform.translatedBy(x: center.x, y: center.y)
//                transform = transform.rotated(by: radians)
//                transform = transform.translatedBy(x: -center.x, y: -center.y)
//                path.apply(transform)
//            }
//            for y in Int(path.bounds.minY)..<Int(path.bounds.maxY) {
//
//                bezier.move(to: CGPoint(x: path.bounds.minX, y: y * 5))
//                bezier.addLine(to: CGPoint(x: path.bounds.maxX, y: y * 5))
//                //bezier.
//                UIColor.yellow.setStroke()
//                bezier.stroke()
//            }
            //bezier.l
                //.}
        
        
        
        //let center = SizeManager.shapeMaxSize
    }
    
//    required init
    
//    required convenience init(imageLiteralResourceName name: String) {
//        fatalError("init(imageLiteralResourceName:) has not been implemented")
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    @objc required convenience init(imageLiteralResourceName name: String) {
//        fatalError("init(imageLiteralResourceName:) has not been implemented")
//    }
//
//    required convenience init(imageLiteralResourceName name: String) {
//        fatalError("init(imageLiteralResourceName:) has not been implemented")
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    required convenience init(imageLiteralResourceName name: String) {
//        fatalError("init(imageLiteralResourceName:) has not been implemented")
//    }
//
//    required convenience init(imageLiteralResourceName name: String) {
//        fatalError("init(imageLiteralResourceName:) has not been implemented")
//    }
    
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    

    

    
//    override func draw(_ rect: CGRect) {
//       // let context = UIGraphicsGetCurrentContext()
//
//        let squareLine = self.bounds.width / 2
//
//        let path = UIBezierPath()
//
//        let leftX = self.center.x - squareLine / 2
//        let rightX = leftX + squareLine
//        let upY = self.center.y - squareLine / 2
//        let downY = upY + squareLine
//
//
//        path.move(to: CGPoint(x: leftX, y: upY))
//        path.addLine(to: CGPoint(x: rightX, y: upY))
//        path.addLine(to: CGPoint(x: rightX, y: downY))
//        path.close()
//
//        UIColor.yellow.setFill()
//        path.fill()
//        //context.
//    }
    
    
        
            
extension ShapeView {
    
    private var shapeLineSize: CGFloat {
        (bounds.height * 2 - bounds.width - itemOffset * 2 - boundMinOffset * 2) / 5
    }
    private var shapeDiagSize: CGFloat {
        shapeLineSize * sqrt(2)
    }
    
    private var shapeStepSize: CGFloat {
        let shapeSpaceAmount = 6 // number of spaces between strip lines
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
        
//        let squareLine = self.bounds.width / 2
//
//        let centerX = self.bounds.midX
//        let centerY = self.bounds.midY
        
//        let path = UIBezierPath(rect: self.bounds)
//
//        let leftX = centerX - squareLine / 2
//        let rightX = leftX + squareLine
//        let upY = centerY - squareLine / 2
//        let downY = upY + squareLine
//
//
//        path.move(to: CGPoint(x: leftX, y: upY))
//        path.addLine(to: CGPoint(x: rightX, y: upY))
//        path.addLine(to: CGPoint(x: rightX, y: downY))
//        path.close()
//        UIColor.blue.setStroke()
//        path.stroke()
//        UIColor.yellow.setFill()
//        path.fill()
        
//        let context = UIGraphicsGetCurrentContext()
//        context?.addPath(path)
}
