//
//  AWSHeartRateSensorData.swift
//  AWSense
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import HealthKit

public class AWSHeartRateSensorData : AWSSensorData {
    
    public private(set) var timestamp : AWSTimestamp
    
    public static var csvHeader : String {
        get{
            return "date,ti,bpm"
        }
    }
    
    public var csvString : String {
        get{
            return "\(timestamp.date),\(timestamp.ti),\(heartRate)"
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
            return [heartRate as AnyObject]
        }
    }
    
    public required init(timestamp : AWSTimestamp, data: [AnyObject]){
        self.timestamp = timestamp
        self.heartRate = data[0] as! Double
    }
    
    public init(timestamp : AWSTimestamp, heartRate : Double){
        self.timestamp = timestamp
        self.heartRate = heartRate
    }
    
}
