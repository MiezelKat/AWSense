//
//  AWSHeartRateSensorData.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import HealthKit

public class AWSHeartRateSensorData : AWSSensorData {
    var _timestamp : AWSTimestamp
    public var timestamp : AWSTimestamp {
        get {
            return _timestamp
        }
    }
    
    public static var csvHeader : String {
        get{
            return "date,ti,bpm"
        }
    }
    
    public var csvString : String {
        get{
            return "\(_timestamp.date),\(_timestamp.ti),\(_heartRate),"
        }
    }
    
    public var prettyPrint : String {
        get{
            return String(format: "%.2f", _heartRate)
        }
    }
    
    private var _heartRate : Double
    
    public var data : [AnyObject] {
        get{
            return [_heartRate as AnyObject]
        }
    }
    
    public required init(timestamp : AWSTimestamp, data: [AnyObject]){
        _timestamp = timestamp
        _heartRate = data[0] as! Double
    }
    
    public init(timestamp : AWSTimestamp, heartRate : Double){
        _timestamp = timestamp
        _heartRate = heartRate
    }
    
}
