//
//  AWSAccelerometerSensorData.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import CoreMotion

public class AWSAccelerometerSensorData : AWSSensorData {
    var _timestamp : AWSTimestamp
    public var timestamp : AWSTimestamp {
        get {
            return _timestamp
        }
    }
    
    public static var csvHeader : String {
        get{
            return "date,ti,x,y,z"
        }
    }
    
    public var csvString : String {
        get{
            return "\(_timestamp.date),\(_timestamp.ti),\(_acceleration.x),\(_acceleration.y),\(_acceleration.z),"
        }
    }
    
    public var prettyPrint : String {
        get{
            return String(format: "%.2f,%.2f,%.2f", _acceleration.x,_acceleration.y,_acceleration.z)
        }
    }
    
    private var _acceleration : CMAcceleration
    
    public var data : [AnyObject] {
        get{
            return [_acceleration as AnyObject]
        }
    }
    
    public required init(timestamp : AWSTimestamp, data: [AnyObject]){
        _timestamp = timestamp
        _acceleration = data[0] as! CMAcceleration
    }
    
    public init(timestamp : AWSTimestamp, acceleration : CMAcceleration){
        _timestamp = timestamp
        _acceleration = acceleration
    }
    
}
