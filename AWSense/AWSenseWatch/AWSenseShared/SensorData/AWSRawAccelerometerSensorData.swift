//
//  AWSRawAccelerometerSensorData.swift
//  AWSense
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import CoreMotion

public class AWSRawAccelerometerSensorData : AWSSensorData {

    public var sensorType : AWSSensorType { return .accelerometer }
    
    public private(set) var timestamp : AWSTimestamp
    
    public static var csvHeader : String {
        get{
            return "date,ti,x,y,z\n"
        }
    }
    
    public var csvHeader : String {
        get{
            return type(of: self).csvHeader
        }
    }
    
    public var csvString : String {
        get{
            return "\(timestamp.date),\(timestamp.ti),\(acceleration.x),\(acceleration.y),\(acceleration.z)\n"
        }
    }
    
    public var prettyPrint : String {
        get{
            return String(format: "%.2f,%.2f,%.2f", acceleration.x,acceleration.y,acceleration.z)
        }
    }
    
    public private(set) var acceleration : CMAcceleration
    
    public var data : [AnyObject] {
        get{
            return [timestamp.data as AnyObject, // 0
                    acceleration.serialise() as AnyObject] // 1
        }
    }
    
    public required init(withData data: [AnyObject]){
        self.timestamp = AWSTimestamp(data: data[0] as! [AnyObject])
        self.acceleration = CMAcceleration(fromData: data[1] as! [AnyObject])
    }
    
    public init(timestamp : AWSTimestamp, acceleration : CMAcceleration){
        self.timestamp = timestamp
        self.acceleration = acceleration
    }
}




