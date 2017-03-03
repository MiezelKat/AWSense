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

    public private(set) var timestamp : AWSTimestamp
    
    public static var csvHeader : String {
        get{
            return "date,ti,x,y,z"
        }
    }
    
    public var csvString : String {
        get{
            return "\(timestamp.date),\(timestamp.ti),\(acceleration.x),\(acceleration.y),\(acceleration.z)"
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
            return [acceleration as AnyObject]
        }
    }
    
    public required init(timestamp : AWSTimestamp, data: [AnyObject]){
        self.timestamp = timestamp
        self.acceleration = data[0] as! CMAcceleration
    }
    
    public init(timestamp : AWSTimestamp, acceleration : CMAcceleration){
        self.timestamp = timestamp
        self.acceleration = acceleration
    }
    
}
