//
//  AWSHeartRateSensorData.swift
//  AWSense
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import HealthKit

public struct AWSHeartRateSensorData : AWSSensorData {
    
    public var sensorType : AWSSensorType { return .heart_rate }
    
    public private(set) var timestamp : AWSTimestamp
    
    public static var csvHeader : String {
        get{
            return "date,ti,bpm\n"
        }
    }
    
    public var csvHeader : String {
        get{
            return type(of: self).csvHeader
        }
    }
    
    public var csvString : String {
        get{
            return "\(timestamp.date),\(timestamp.ti),\(heartRate)\n"
        }
    }
    
    public var prettyPrint : String {
        get{
            return String(format: "%.2f", heartRate)
        }
    }
    
    public private(set) var heartRate : Double
    
    public var data : [AnyObject] {
        get{
            return [timestamp.data as AnyObject, // 0
                    heartRate as AnyObject] // 1
        }
    }
    
    public init(withData data: [AnyObject]){
        self.timestamp = AWSTimestamp(data: data[0] as! [AnyObject])
        self.heartRate = data[1] as! Double
    }
    
    public init(timestamp : AWSTimestamp, heartRate : Double){
        self.timestamp = timestamp
        self.heartRate = heartRate
    }
    
}
