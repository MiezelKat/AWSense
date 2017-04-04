//
//  GraphView.swift
//  MobiSys-Demo
//
//  Created by Katrin Haensel on 30/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import UIKit
import GLKit

class CircleClosing: UIView {
    
    var _x : Double = 0
    var _y : Double = 0
    var _z : Double = 0
    
    func set(x: Double, y: Double, z: Double){
        _x = x
        _y = y
        _z = z
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
    
    // MARK: Properties
    let centerX:Double = 55.0
    let centerY:Double = 55.0
    let radius:CGFloat = 50
    
    var currentAngle:Float = -90
    
    let timeBetweenDraw:CFTimeInterval = 0.01
    
    // MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        print("setup")
        self.backgroundColor = UIColor.lightGray
        //Timer.scheduledTimer(timeInterval: timeBetweenDraw, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // MARK: Drawing
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        let path = CGMutablePath()
        
        let width = Double(self.bounds.size.width)
        let height = Double(self.bounds.size.height)
        
        let centerX = width / 2.0
        let centerY = height / 2.0
        
        let multiplier = (width > height ? height/2.0 : width/2.0) - 5.0
        
        let (x,y) = calcXandY()
        
        let xC = centerX + (x * multiplier)
        let yC = centerY + (y * multiplier)
        
        path.addEllipse(in: CGRect(x: xC, y: yC, width: 10.0, height: 10.0))
        
        context!.addPath(path)
        context!.setStrokeColor(UIColor.blue.cgColor)
        context!.setLineWidth(3)
        context!.strokePath()
    }
    
    func calcXandY() -> (Double, Double){
        
        let divider = sqrt(_x * _x + _y * _y + _z * _z)
        
        let xRes = _x / divider
        
        let yRes = -_y / divider
        
        return (xRes, yRes)
    }
}
