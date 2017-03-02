//
//  AWSDeviceMotionSensorData.swift
//  AWSense
//
//  Created by Katrin Haensel on 21/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import CoreMotion

public class AWSDeviceMotionSensorData : AWSSensorData {
    
    public private(set) var timestamp : AWSTimestamp
    
    public static var csvHeader : String {
        get{
            return "date,ti,accel_x,accel_y,accel_z,gyro_x,gyro_y,gyro_z,grav_x,grav_y,grav_z,atti_pitch,atti_roll,atti_yaw"
        }
    }
    
    public var csvString : String {
        get{
            return "\(timestamp.date),\(timestamp.ti),\(linearAcceleration.x),\(linearAcceleration.y),\(linearAcceleration.z),\(rotationRate.x),\(rotationRate.y),\(rotationRate.z),\(gravity.x),\(gravity.y),\(gravity.z),\(attitude.pitch),\(attitude.roll),\(attitude.yaw)"
        }
    }
    
    public var prettyPrint : String {
        get{
            return String(format: "a:%.2f,%.2f,%.2f\nr:%.2f,%.2f,%.2f\ng:%.2f,%.2f,%.2f\na:%.2f,%.2f,%.2f\nat:%.2f,%.2f,%.2f",
                linearAcceleration.x,linearAcceleration.y,linearAcceleration.z,
                rotationRate.x,rotationRate.y,rotationRate.z,
                gravity.x,gravity.y,gravity.z,
                attitude.pitch,attitude.roll,attitude.yaw)
        }
    }
    
    public private(set) var linearAcceleration : CMAcceleration
    public private(set) var rotationRate : CMRotationRate
    public private(set) var gravity : CMAcceleration
    public private(set) var attitude : CMAttitude
    
    
    public var data : [AnyObject] {
        get{
            return [linearAcceleration as AnyObject,
                    rotationRate as AnyObject,
                    gravity as AnyObject,
                    attitude as AnyObject] as [AnyObject]
        }
    }
    
    public required init(timestamp : AWSTimestamp, data: [AnyObject]){
        self.timestamp = timestamp
        self.linearAcceleration = data[0] as! CMAcceleration
        self.rotationRate = data[0] as! CMRotationRate
        self.gravity = data[0] as! CMAcceleration
        self.attitude = data[0] as! CMAttitude
    }
    
    public init(timestamp : AWSTimestamp, deviceMotion : CMDeviceMotion){
        self.timestamp = timestamp
        linearAcceleration = deviceMotion.userAcceleration
        rotationRate = deviceMotion.rotationRate
        gravity = deviceMotion.gravity
        attitude = deviceMotion.attitude
    }
    
}
