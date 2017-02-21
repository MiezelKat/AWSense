//
//  SensorTypes.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 16/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation

/// Enum with different sensor types for AWSense
public enum AWSSensorType : Int, Equatable {
    
    case heart_rate = 0
    case accelerometer
    case ambinent_light
    case microphone
    case bluetooth
    case device_motion
    
    ///The hashValue of the `Component` so we can conform to `Hashable` and be sorted.
    public var hashValue : Int {
        return self.rawValue
    }
    
    public func isEqualTo(another: AWSSensorType) -> Bool{
        if another is AWSSensorType{
            return self.rawValue == (another).rawValue
        }else{
            return false
        }
    }
}
