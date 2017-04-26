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
    
    public     var sensorType : AWSSensorType { return .device_motion }
    
    public private(set) var timestamp : AWSTimestamp
    
    public static var csvHeader : String {
        get{
            return "date,ti,accel_x,accel_y,accel_z,gyro_x,gyro_y,gyro_z,grav_x,grav_y,grav_z,atti_pitch,atti_roll,atti_yaw\n"
        }
    }
    
    public var csvHeader : String {
        get{
            return type(of: self).csvHeader
        }
    }
    
    public var csvString : String {
        get{
            return "\(timestamp.date),\(timestamp.ti),\(linearAcceleration.x),\(linearAcceleration.y),\(linearAcceleration.z),\(rotationRate.x),\(rotationRate.y),\(rotationRate.z),\(gravity.x),\(gravity.y),\(gravity.z),\(attitude.pitch),\(attitude.roll),\(attitude.yaw)\n"
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
    public private(set) var attitude : Attitude
    
    
    public var data : [AnyObject] {
        get{
            return [timestamp.data as AnyObject, // 0
                    linearAcceleration.serialise() as AnyObject, // 1
                    rotationRate.serialise() as AnyObject, // 2
                    gravity.serialise() as AnyObject, //3
                    attitude.serialise() as AnyObject] as [AnyObject] // 4
        }
    }
    
    public required init(withData data: [AnyObject]){
        self.timestamp = AWSTimestamp(data: data[0] as! [AnyObject])
        self.linearAcceleration =  CMAcceleration(fromData: data[1] as! [AnyObject])
        self.rotationRate = CMRotationRate(fromData: data[2] as! [AnyObject])
        self.gravity =  CMAcceleration(fromData: data[3] as! [AnyObject])
        self.attitude = Attitude(fromData: data[4] as! [AnyObject])
    }
    
    public init(timestamp : AWSTimestamp, deviceMotion : CMDeviceMotion){
        self.timestamp = timestamp
        linearAcceleration = deviceMotion.userAcceleration
        rotationRate = deviceMotion.rotationRate
        gravity = deviceMotion.gravity
        attitude = Attitude(fromCM: deviceMotion.attitude)
    }
    
}
