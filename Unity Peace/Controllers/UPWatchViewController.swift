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
    
    @IBOutlet weak var dialView: UIView!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNeedles()
        self.dialView.layer.cornerRadius = self.dialView.frame.size.width / 2
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    
    @objc func locationDidUpdate (notif : Notification) {
        if let newLocation = notif.object as? CLLocation {
            NSLog("Got new location \(String(describing: newLocation))")
            let cal = Calendar(identifier: Calendar.Identifier.gregorian)
            let date = cal.dateComponents([.year, .month, .day], from: Date())
            let coordinates = Coordinates(latitude: 12.8215893276892, longitude: 77.6570353668526)
            var params = CalculationMethod.muslimWorldLeague.params
            params.madhab = .hanafi
            if let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params) {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                formatter.timeZone = TimeZone.current
                
                NSLog("fajr %@", formatter.string(from: prayers.fajr))
                self.setTime(needle: self.fajr, time: formatter.string(from: prayers.fajr))
                NSLog("sunrise %@", formatter.string(from: prayers.sunrise))
                NSLog("dhuhr %@", formatter.string(from: prayers.dhuhr))
                self.setTime(needle: self.dhuhr, time: formatter.string(from: prayers.dhuhr))
                NSLog("asr %@", formatter.string(from: prayers.asr))
                self.setTime(needle: self.asr, time: formatter.string(from: prayers.asr))
                NSLog("maghrib %@", formatter.string(from: prayers.maghrib))
                self.setTime(needle: self.maghrib, time: formatter.string(from: prayers.maghrib))
                NSLog("isha %@", formatter.string(from: prayers.isha))
                self.setTime(needle: self.isha, time: formatter.string(from: prayers.isha))

            }
        }
    }

    func setTime (needle: UIView, time : String?) {
        guard time != nil else {
            return
        }
        let components = time!.components(separatedBy: ":")
        guard components.count == 2 else {
            return
        }
        let hours = Float(components[0])
        let minutes = Float(components[1])
        
        guard hours != nil, minutes != nil else {
            return
        }
        
        var angle  = 15 * hours!
        angle += (0.25 * minutes!)
        //angle -= 90.0
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
    
    func setUpNeedles() {
        

        let radians = (CGFloat(90) / 180) * CGFloat(Double.pi)
        self.asr.transform = asr.transform.rotated(by: radians)
        self.fajr.transform = fajr.transform.rotated(by: radians)
        self.dhuhr.transform = dhuhr.transform.rotated(by: radians)
        self.maghrib.transform = maghrib.transform.rotated(by: radians)
        self.isha.transform = isha.transform.rotated(by: radians)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationDidUpdate(notif:)), name: LocationManager.LocationDidUpdateNotification, object: nil)
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

