//
//  UPWatchViewController.swift
//  Unity Peace
//
//  Created by bsingh9 on 06/11/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import Adhan
import CoreLocation

class UPWatchViewController: UIViewController {
    
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var dialView: UIView!
    
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var sunrise: UIView!
    @IBOutlet weak var sunriseNeedle: UIImageView!
    @IBOutlet weak var fajr: UIView!
    @IBOutlet weak var firstNeedle: UIImageView!
    @IBOutlet weak var dhuhr: UIView!
    @IBOutlet weak var secondNeedle: UIImageView!
    @IBOutlet weak var asr: UIView!
    @IBOutlet weak var thirdNeedle: UIImageView!
    @IBOutlet weak var maghrib: UIView!
    @IBOutlet weak var fourthNeedle: UIImageView!
    @IBOutlet weak var isha: UIView!
    @IBOutlet weak var fifthNeedle: UIImageView!
    @IBOutlet weak var hourNeedleView: UIView!
    @IBOutlet weak var hourNeedle: UIImageView!
    @IBOutlet weak var arcView: Ring!
    
    @IBOutlet weak var middleContainerView: UIView!
    @IBOutlet weak var middleView: UIView!

    @IBOutlet weak var sunsetlbl: UILabel!
    @IBOutlet weak var sunriselbl: UILabel!
    var location : CLLocation?
    var graydientLayerCreated = false
    
    @IBOutlet weak var topFrameWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var width = self.topFrameWidthConstraint.constant
        switch UIDevice.current.deviceCategory() {
        case .iPhone6Plus:
            width = 380
        case .iPhone4, .iPhone5:
            width = 300
        default:
            break
        }
        
        self.topFrameWidthConstraint.constant = width
    
        self.middleContainerView.putShadow()
        self.frameView.putShadow()
        
        let radians = (CGFloat(-90) / 180) * CGFloat(Double.pi)
        self.sunriselbl.transform = sunriselbl.transform.rotated(by: radians)
        let radians1 = (CGFloat(90) / 180) * CGFloat(Double.pi)
        self.sunsetlbl.transform = sunsetlbl.transform.rotated(by: radians1)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.locationDidUpdate(notif:)), name: LocationManager.LocationDidUpdateNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !self.graydientLayerCreated {
            self.graydientLayerCreated = true
            self.frameView.createGradientLayer(colors: [UIColor.lightGray.cgColor, UIColor.gray.cgColor])
            self.frameView.layer.cornerRadius = self.frameView.frame.size.width / 2
            self.dialView.layer.cornerRadius = self.dialView.frame.size.width / 2
            self.numberView.layer.cornerRadius = self.numberView.frame.size.width / 2
            self.middleContainerView.layer.cornerRadius = self.middleContainerView.frame.size.width / 2
            self.middleView.layer.cornerRadius = self.middleView.frame.size.width / 2
            self.arcView.layer.cornerRadius = self.arcView.frame.size.width / 2

        }
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    
    @objc func locationDidUpdate (notif : Notification) {
        guard self.location == nil else {
            return
        }
        if let newLocation = notif.object as? CLLocation {
            self.location = newLocation
            self.UpdateUI()
        }
    }
    
    func UpdateUI () {
        let newLocation = self.location!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = TimeZone.current
        self.timeLabel.text = formatter.string(from: Date())
        
        formatter.dateFormat = "dd-MMM-yy"
        self.dateLabel.text = formatter.string(from: Date())
        
        self.hourNeedleView.transform = CGAffineTransform.identity
        self.fajr.transform = CGAffineTransform.identity
        self.dhuhr.transform = CGAffineTransform.identity
        self.sunrise.transform = CGAffineTransform.identity
        self.asr.transform = CGAffineTransform.identity
        self.maghrib.transform = CGAffineTransform.identity
        self.isha.transform = CGAffineTransform.identity
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        let coordinates = Coordinates(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        var params = CalculationMethod.muslimWorldLeague.params
        params.madhab = .hanafi
        if let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone.current
            let currentTime = formatter.string(from: Date())
            NSLog("Now %@",currentTime)
            self.setTime(needle: self.hourNeedleView, time: currentTime)
            NSLog("fajr %@", formatter.string(from: prayers.fajr))
            self.setTime(needle: self.fajr, time: formatter.string(from: prayers.fajr))
            NSLog("sunrise %@", formatter.string(from: prayers.sunrise))
            self.setTime(needle: self.sunrise, time: formatter.string(from: prayers.sunrise))
            NSLog("dhuhr %@", formatter.string(from: prayers.dhuhr))
            self.setTime(needle: self.dhuhr, time: formatter.string(from: prayers.dhuhr))
            NSLog("asr %@", formatter.string(from: prayers.asr))
            self.setTime(needle: self.asr, time: formatter.string(from: prayers.asr))
            NSLog("maghrib %@", formatter.string(from: prayers.maghrib))
            self.setTime(needle: self.maghrib, time: formatter.string(from: prayers.maghrib))
            NSLog("isha %@", formatter.string(from: prayers.isha))
            self.setTime(needle: self.isha, time: formatter.string(from: prayers.isha))
            
            let times  = [prayers.fajr, prayers.dhuhr, prayers.asr, prayers.maghrib, prayers.isha]
            let now = Date()
            NSLog("Debug \(now)")
            var index = 0
            while now >= times[index] {
                index += 1
                if index == times.count {
                    break
                }
            }
            
            if index == times.count {
                let startAngle = self.getAngleFromTime(time: formatter.string(from: times[index - 1]))
                let endAngle = 90
                self.arcView.drawRingFittingInsideView(startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle))
                self.arcView.drawRingFittingInsideView(startAngle: CGFloat(90), endAngle: CGFloat(self.getAngleFromTime(time: formatter.string(from: times[0]))))
                
            }else if index == 0 {
                let startAngle = self.getAngleFromTime(time: formatter.string(from: times.last!))
                let endAngle = 90
                self.arcView.drawRingFittingInsideView(startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle))
                self.arcView.drawRingFittingInsideView(startAngle: CGFloat(90), endAngle: CGFloat(self.getAngleFromTime(time: formatter.string(from: times[0]))))
            }
            else {
                NSLog("Current Prayer %@", formatter.string(from: times[index]))
                let startAngle = self.getAngleFromTime(time: formatter.string(from: times[index - 1]))
                let endAngle = self.getAngleFromTime(time: formatter.string(from: times[index]))
                self.arcView.drawRingFittingInsideView(startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle))
                
            }
        }

    }
    
    func getAngleFromTime(time : String) -> Float {
        let components = time.components(separatedBy: ":")
        guard components.count == 2 else {
            return 0
        }
        let hours = Float(components[0])
        let minutes = Float(components[1])
        
        guard hours != nil, minutes != nil else {
            return 0
        }
        
        var angle  = 15 * hours!
        angle += (0.25 * minutes!)
        angle += 90.0
        return angle
    }

    func setTime (needle: UIView, time : String?) {
        guard time != nil else {
            return
        }
        let angle = self.getAngleFromTime(time: time!)
        
        NSLog("Time \(String(describing: time)), angle \(angle)")
        switch needle {
        case self.asr:
            self.rotateView(targetView: self.asr, degrees: angle)
        case self.fajr:
            self.rotateView(targetView: self.fajr, degrees: angle)
        case self.dhuhr:
            self.rotateView(targetView: self.dhuhr, degrees: angle)
        case self.maghrib:
            self.rotateView(targetView: self.maghrib, degrees: angle)
        case self.isha:
            self.rotateView(targetView: self.isha, degrees: angle)
        case self.sunrise:
            self.rotateView(targetView: self.sunrise, degrees: angle)
        case self.hourNeedleView:
            self.rotateView(targetView: self.hourNeedleView, degrees: angle)
        default:
            break
        }
        
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
        
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        layer.addSublayer(shapeLayer)
    }
}

class PrayerInfoView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let size = self.bounds.size
        
        context.translateBy (x: size.width / 2, y: size.height / 2)
        context.scaleBy (x: 1, y: -1)
        
        centreArcPerpendicular(text: "MAG", context: context, radius: rect.width / 2 - 12, angle: CGFloat(-0.12), colour: UIColor.white, font: UIFont.boldSystemFont(ofSize: 12), clockwise: true)
        centreArcPerpendicular(text: "ISHA", context: context, radius: rect.width / 2 - 12, angle: CGFloat(-0.40), colour: UIColor.white, font: UIFont.boldSystemFont(ofSize: 12), clockwise: true)
        centreArcPerpendicular(text: "FAJR", context: context, radius: rect.width / 2 - 12, angle: CGFloat(-Double.pi), colour: UIColor.white, font: UIFont.boldSystemFont(ofSize: 12), clockwise: true)
        centreArcPerpendicular(text: "DHUHR", context: context, radius: rect.width / 2 - 12, angle: CGFloat(Double.pi / 2 - 0.3), colour: UIColor.white, font: UIFont.boldSystemFont(ofSize: 12), clockwise: true)
        centreArcPerpendicular(text: "ASAR", context: context, radius: rect.width / 2 - 12, angle: CGFloat(0.30), colour: UIColor.white, font: UIFont.boldSystemFont(ofSize: 12), clockwise: true)
        
    }
}


class NumberView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let size = self.bounds.size
        
        context.translateBy (x: size.width / 2, y: size.height / 2)
        context.scaleBy (x: 1, y: -1)
        
        let totalAngle = 2.0 * Double.pi
        for index in 0...120 {
            let angle  = Double(index) * totalAngle / 120
            centreArcPerpendicular(text: "|", context: context, radius: rect.width / 2 - 20, angle: CGFloat(angle), colour: UIColor.gray, font: UIFont.boldSystemFont(ofSize: 5), clockwise: true)
            
        }
        for index in 1...24 {
            let angle  = Double(index) * totalAngle / 24
            centreArcPerpendicular(text: "\(index)", context: context, radius: rect.width / 2 - 10, angle: CGFloat(-angle), colour: UIColor.gray, font: UIFont.systemFont(ofSize: 8), clockwise: true)
            
        }
        
        let hours = [7, 8, 9, 10, 11, 12, 1, 2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6]
        var index = 1
        for hour in hours {
            let angle  = Double(index) * totalAngle / 24
            centreArcPerpendicular(text: "\(hour)", context: context, radius: rect.width / 2 - 35, angle: CGFloat(-angle), colour: UIColor.black, font: UIFont.boldSystemFont(ofSize: 8), clockwise: true)
            index += 1
        }
        
//        let point = CGPoint(x: 100, y: 100 )
//        let font = UIFont.systemFont(ofSize: 10)
//        self.drawRotatedText("SUNRISE", at: point, angle: CGFloat(Double.pi), font: font, color: .gray)
        
        
    }
}

