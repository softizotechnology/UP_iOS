//
//  UPWatchViewController.swift
//  Unity Peace
//
//  Created by bsingh9 on 06/11/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit

class UPWatchViewController: UIViewController {
    
    @IBOutlet weak var dialView: UIView!
    @IBOutlet weak var firstNeedleContainer: UIView!
    @IBOutlet weak var firstNeedle: UIImageView!
    @IBOutlet weak var secondNeedleContainer: UIView!
    @IBOutlet weak var secondNeedle: UIImageView!
    @IBOutlet weak var thirdNeedleContainer: UIView!
    @IBOutlet weak var thirdNeedle: UIImageView!
    @IBOutlet weak var fourthNeedleView: UIView!
    @IBOutlet weak var fourthNeedle: UIImageView!
    @IBOutlet weak var fifthNeedleContainer: UIView!
    @IBOutlet weak var fifthNeedle: UIImageView!
    @IBOutlet weak var hourNeedleView: UIView!
    @IBOutlet weak var hourNeedle: UIImageView!
    @IBOutlet weak var arcView: Ring!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dialView.layer.cornerRadius = self.dialView.frame.size.width / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.perform(#selector(self.setNeedles), with: nil, afterDelay: 1.0)
        
    }

    
    func drawGradientOver(container: UIView) {
        let black = UIColor.black
        let maskLayer = CAGradientLayer()
        maskLayer.opacity = 0.8
        maskLayer.colors = [black.cgColor, UIColor.gray.cgColor]
        
        // Hoizontal - commenting these two lines will make the gradient veritcal
        maskLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        maskLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        let gradTopStart = NSNumber(value: 0.0)
        let gradTopEnd = NSNumber(value: 0.5)
        let gradBottomStart = NSNumber(value: 0.5)
        let gradBottomEnd = NSNumber(value: 1.0)
        maskLayer.locations = [gradTopStart, gradTopEnd, gradBottomStart, gradBottomEnd]
        
        maskLayer.bounds = container.bounds
        maskLayer.anchorPoint = CGPoint.zero
        container.layer.addSublayer(maskLayer)
    }
   

    func setNeedles () {
        self.rotateView(targetView: self.secondNeedleContainer, degrees : 20)
        self.rotateView(targetView: self.thirdNeedleContainer, degrees : 170)
        self.rotateView(targetView: self.fourthNeedleView, degrees : 270)
        self.rotateView(targetView: self.fifthNeedleContainer, degrees: 315)
        self.rotateView(targetView: self.hourNeedleView, degrees: 34)
        self.arcView.drawRingFittingInsideView(startAngle: 0, endAngle: 20)
        
    }
    
    private func rotateView(targetView: UIView, duration: Double = 1.0, degrees : Float) {
        var shouldContinueRotation = false
        var rotationAngle = degrees
        if degrees > 180 {
            shouldContinueRotation = true
            rotationAngle = 180
        }
        let radians = (CGFloat(rotationAngle) / 180) * CGFloat(Double.pi)
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: radians)
        }) { finished in
            if shouldContinueRotation {
                shouldContinueRotation = false
                self.rotateView(targetView: targetView, duration: 0.3, degrees: (degrees - 180 ))
            }
        }
    }

}

class Ring:UIView
{
    
    func drawRingFittingInsideView(startAngle: CGFloat, endAngle : CGFloat)
    {
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat =  bounds.size.width/2   // your desired value
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat( halfSize - (desiredLineWidth/2) ),
            startAngle: (CGFloat(startAngle) / 180) * CGFloat(Double.pi),
            endAngle: (CGFloat(endAngle) / 180) * CGFloat(Double.pi),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        
        layer.addSublayer(shapeLayer)
    }
}

