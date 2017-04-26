//
//  SensorExtensions.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 06/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import CoreMotion

extension CMAcceleration{
    
    func serialise() -> [AnyObject]{
        return [self.x as AnyObject, self.y as AnyObject, self.z as AnyObject]
    }
    
    init(fromData data: [AnyObject]){
        self.init()
        self.x = data[0] as! Double
        self.y = data[1] as! Double
        self.z = data[2] as! Double
    }
}

extension CMRotationRate{
    
    func serialise() -> [AnyObject]{
        return [self.x as AnyObject, self.y as AnyObject, self.z as AnyObject]
    }
    
    init(fromData data: [AnyObject]){
        self.init()
        self.x = data[0] as! Double
        self.y = data[1] as! Double
        self.z = data[2] as! Double
    }
}

public struct Attitude{
    
    var pitch : Double
    var yaw : Double
    var roll : Double
    
    func serialise() -> [AnyObject]{
        return [self.pitch as AnyObject, self.roll as AnyObject, self.yaw as AnyObject]
    }
    
    init(fromData data: [AnyObject]){
        self.pitch = data[0] as! Double
        self.roll = data[1] as! Double
        self.yaw = data[2] as! Double
    }
    
    init(fromCM cm: CMAttitude){
        self.pitch = cm.pitch
        self.roll = cm.roll
        self.yaw = cm.yaw
    }
}
