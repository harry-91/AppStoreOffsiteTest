//
//  RateDisplayView.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation
import UIKit

class RateDisplayView: UIView {

    var currentRating: CGFloat = 0 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    
    fileprivate var padding: CGFloat {
        return self.bounds.width / 50
    }
    fileprivate lazy var starsView: UIView = {
        let starsView = UIView(frame: self.bounds)
        starsView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        starsView.backgroundColor = .white
        
        self.addSubview(starsView)
        
        return starsView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.red
    }

    override func draw(_ rect: CGRect) {
        starsView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let width = (rect.width - 4 * padding) / 5
        let height = rect.height > width ? width : rect.height

        var layers = [CALayer]()
        for index in 0..<5 {
            let starRect = CGRect(x: CGFloat(index) * (width + padding),
                                  y: (rect.height - height) / 2,
                                  width: width,
                                  height: height)
            
            let filledPercentage = starFilledPercentage(withIndex: index)
            
            var starLayer: CALayer!
            if filledPercentage >= 1 {
                starLayer = self.starLayer(in: starRect, isFilled: true)
            } else if filledPercentage <= 0 {
                starLayer = self.starLayer(in: starRect, isFilled: false)
            } else {
                let filledStarLayer = self.starLayer(in: starRect, isFilled: true)
                let emptyStarLayer = self.starLayer(in: starRect, isFilled: false)
                
                let partialStarLayer = CALayer()
                partialStarLayer.addSublayer(emptyStarLayer)
                partialStarLayer.addSublayer(filledStarLayer)
                
                let newWidth = filledStarLayer.bounds.size.width * CGFloat(filledPercentage)
                let offset = (filledStarLayer.bounds.size.width - newWidth) / 2
                
                filledStarLayer.bounds.size.width = newWidth
                filledStarLayer.frame.origin.x -= offset
                
                starLayer = partialStarLayer
            }

            layers.append(starLayer)
        }
        
        starsView.layer.sublayers = layers
    }

    fileprivate func starLayer(in rect: CGRect, isFilled: Bool) -> CALayer {
        let starLayer = CAShapeLayer()
        starLayer.frame = rect
        starLayer.fillColor = isFilled ? UIColor.orange.cgColor : UIColor.clear.cgColor
        starLayer.strokeColor = UIColor.orange.cgColor
        
        starLayer.masksToBounds = true
        starLayer.isOpaque = true
        
        let starPath = drawStarBezier(withOrigin: CGPoint(x: rect.width / 2,
                                                          y: rect.height / 2),
                                      radius: rect.width / 4,
                                      pointyness: 2)
        starLayer.path = starPath.cgPath
    
        return starLayer
    }
    
    fileprivate func starFilledPercentage(withIndex index: Int) -> Float {
        return Float(currentRating - CGFloat(index + 1))
    }


    // MARK: - Draw Polygon

    fileprivate func degree2radian(_ degree: CGFloat) -> CGFloat {
        return .pi * degree / 180
    }

    fileprivate func polygonPoints(withSides sides: Int, origin: CGPoint, radius: CGFloat, adjustment: CGFloat = 0) -> [CGPoint] {
        let angle = degree2radian(360 / CGFloat(sides))
        var points = [CGPoint]()

        var index = sides

        while points.count <= sides {
            points.append(CGPoint(x: origin.x - radius * cos(angle * CGFloat(index) + degree2radian(adjustment)),
                                  y: origin.y - radius * sin(angle * CGFloat(index) + degree2radian(adjustment))))

            index = index - 1
        }

        return points
    }


    // MARK: - Draw Star

    fileprivate func starPath(withOrigin origin: CGPoint, radius: CGFloat, pointyness: CGFloat, startAngle: CGFloat = 0) -> CGPath {
        let adjustment = startAngle + CGFloat(360 / 5 / 2)
        let path = CGMutablePath()
        let polygonPoints = self.polygonPoints(withSides: 5, origin: origin, radius: radius, adjustment: startAngle)
        let biggerPolygonPoints = self.polygonPoints(withSides: 5, origin: origin, radius: radius * pointyness, adjustment: adjustment)

        path.move(to: CGPoint(x:polygonPoints[0].x,
                              y:polygonPoints[0].y))
        for index in 0..<polygonPoints.count {
            path.addLine(to: CGPoint(x:biggerPolygonPoints[index].x, y:biggerPolygonPoints[index].y))
            path.addLine(to: CGPoint(x:polygonPoints[index].x, y:polygonPoints[index].y))
        }

        path.closeSubpath()
        return path
    }


    fileprivate func drawStarBezier(withOrigin origin: CGPoint, radius: CGFloat, pointyness: CGFloat) -> UIBezierPath {

        let startAngle = CGFloat(-1 * (360 / 5 / 4))

        return UIBezierPath(cgPath: starPath(withOrigin: origin, radius: radius, pointyness: pointyness, startAngle: startAngle))
    }

}
