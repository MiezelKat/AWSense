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
    
    public static let supportedSensors : [AWSSensorType] = [
        .heart_rate, .accelerometer, .device_motion
    ]
    
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
    
    public var short : String{
        switch self{
        case .heart_rate:
            return "hr"
        case .accelerometer:
            return "ac"
        case .ambinent_light:
            return "al"
        case .microphone:
            return "mp"
        case .bluetooth:
            return "bl"
        case .device_motion:
            return "dm"
        }
    }
    
    public var csvHeader : String{
        switch self {
        case .heart_rate:
            return AWSHeartRateSensorData.csvHeader
        case .accelerometer:
            return AWSRawAccelerometerSensorData.csvHeader
        case .device_motion:
            return AWSDeviceMotionSensorData.csvHeader
        default:
            return ""
        }
    }
}
