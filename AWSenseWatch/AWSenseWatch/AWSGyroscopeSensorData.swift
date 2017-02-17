//
//  AWSGyroscopeSensorData.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import CoreMotion

public class AWSGyroscopeSensorData : AWSSensorData {
    
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
            return "\(_timestamp.date),\(_timestamp.ti),\(_rotation.x),\(_rotation.y),\(_rotation.z),"
        }
    }
    
    public var prettyPrint : String {
        get{
            return String(format: "%.2f,%.2f,%.2f", _rotation.x,_rotation.y,_rotation.z)
        }
    }
    
    private var _rotation : CMRotationRate
    
    public var data : [AnyObject] {
        get{
            return [_rotation as AnyObject]
        }
    }
    
    public required init(timestamp : AWSTimestamp, data: [AnyObject]){
        _timestamp = timestamp
        _rotation = data[0] as! CMRotationRate
    }
    
    public init(timestamp : AWSTimestamp, rotationRate : CMRotationRate){
        _timestamp = timestamp
        _rotation = rotationRate
    }
    
}
