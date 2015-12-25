//
//  LoadingBoxesView.swift
//  LoadingBoxesView
//
//  Created by Jose Luis Piedrahita on 21/12/15.
//  Copyright © 2015 Parallel Mobile. All rights reserved.
//

import UIKit

class LoadingBoxesView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.addSublayer(sceneLayer())
    }
    
    private func sceneLayer(
        boxSize: CGFloat = 40,
        boxColor: UIColor = UIColor(hue: 49/360, saturation: 0.78, brightness: 1, alpha: 1),
        animationSpeed: CFTimeInterval = 2.5) -> CALayer {
            
            let sceneLayer = CATransformLayer()
            
            // 4 boxes
            let numberOfBoxes = 4
            
            for boxIndex in 0 ..< numberOfBoxes {
                let box = boxLayer(color:boxColor)
                box.addAnimation(boxAnimation(duration: animationSpeed, timeOffset: animationSpeed / Double(numberOfBoxes) * Double(boxIndex)), forKey: nil)
                sceneLayer.addSublayer(box)
            }
            
            sceneLayer.transform = CATransform3DTranslate(sceneLayer.transform, (self.bounds.size.width / 2) - 20, 0, 0)
            sceneLayer.transform = CATransform3DScale(sceneLayer.transform, boxSize, boxSize, boxSize)
            
            // orthogonal projection
            sceneLayer.transform = CATransform3DRotate(sceneLayer.transform, CGFloat(M_PI_4), 1, 0, 0)
            sceneLayer.transform = CATransform3DRotate(sceneLayer.transform, CGFloat(M_PI_4), 0, 0, 1)
            
            return sceneLayer
    }
    
    private func boxAnimation(duration duration: CFTimeInterval, timeOffset: CFTimeInterval) -> CAAnimation {
        
        let boxAnimation = CAKeyframeAnimation(keyPath: "position")
        boxAnimation.repeatCount = Float.infinity
        boxAnimation.timeOffset = timeOffset
        boxAnimation.duration = duration
        
        boxAnimation.values = [
            NSValue(CGPoint:CGPointMake(0, 0)),
            NSValue(CGPoint:CGPointMake(1, 0)),
            NSValue(CGPoint:CGPointMake(1, 1)),
            NSValue(CGPoint:CGPointMake(0, 1)),
            NSValue(CGPoint:CGPointMake(0, 1)),
            NSValue(CGPoint:CGPointMake(-1, 1)),
            NSValue(CGPoint:CGPointMake(-1, 0)),
            NSValue(CGPoint:CGPointMake(0, 0)),
            NSValue(CGPoint:CGPointMake(0, 0))
        ]
        
        return boxAnimation
    }
    
    private func boxLayer(color color: UIColor) -> CALayer {
        
        let topFaceLayer = CALayer()
        topFaceLayer.frame = CGRectMake(0, 0, 1, 1)
        topFaceLayer.backgroundColor = color.CGColor
        
        let frontFaceLayer = CALayer()
        frontFaceLayer.anchorPoint = CGPointMake(0, 1)
        frontFaceLayer.frame = CGRectMake(0, 0, 1, 1)
        frontFaceLayer.transform = CATransform3DMakeRotation(CGFloat(M_PI_2), 1, 0, 0)
        frontFaceLayer.backgroundColor = color.darkerColor().CGColor
        
        let rightFaceLayer = CALayer()
        rightFaceLayer.anchorPoint = CGPointMake(1, 0)
        rightFaceLayer.frame = CGRectMake(0, 0, 1, 1)
        rightFaceLayer.transform = CATransform3DMakeRotation(CGFloat(-M_PI_2), 0, 1, 0)
        rightFaceLayer.backgroundColor = color.darkerColor().darkerColor().CGColor
        
        let shadowLayer = CALayer()
        shadowLayer.frame = CGRectMake(0, 0, 1, 1)
        shadowLayer.transform = CATransform3DMakeTranslation(0, 0, -4)
        shadowLayer.backgroundColor = UIColor(white: 0.9, alpha: 1).CGColor
        
        let boxLayer = CATransformLayer()
        boxLayer.sublayers = [topFaceLayer, frontFaceLayer, rightFaceLayer, shadowLayer]
        
        return boxLayer
    }
    
}

extension UIColor {
    
    func darkerColor() -> UIColor {
        
        var hue:CGFloat = 0, saturation:CGFloat = 0, brightness:CGFloat = 0, alpha:CGFloat = 0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: max(brightness - 0.2, 0), alpha: alpha)
        } else {
            return self
        }
    }
    
}

