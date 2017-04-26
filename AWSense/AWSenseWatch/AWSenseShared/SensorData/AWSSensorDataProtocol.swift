//
//  AWSSensorDataProtocol.swift
//  AWSense
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation


public protocol AWSSensorData{
    var timestamp : AWSTimestamp { get }
    
    var sensorType : AWSSensorType { get }
    
    static var csvHeader : String { get }
    var csvHeader : String { get }
    
    var csvString : String { get }
    var prettyPrint : String {get}
    
    var data : [AnyObject] { get }
    
    init(withData data: [AnyObject])
}


public class AWSSensorDataParser{
    
    public static func parse(fromData data: [AnyObject], forType type: AWSSensorType) -> AWSSensorData?{
        switch type {
        case .heart_rate:
            return AWSHeartRateSensorData(withData: data)
        case .accelerometer:
            return AWSRawAccelerometerSensorData(withData: data)
        case .device_motion:
            return AWSDeviceMotionSensorData(withData: data)
        default:
            return nil
        }
    }
    
}

