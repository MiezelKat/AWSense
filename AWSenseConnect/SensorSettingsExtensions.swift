//
//  SensorSettingsExtensions.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 23/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared


internal extension RawAccelerometerSensorSettings{
    internal func serialise() -> [AnyObject]{
        return [self.sensorType.rawValue as AnyObject, self.updateIntervallHz as AnyObject] as [AnyObject]
    }
}

internal extension DeviceMotionSensorSettings{
    internal func serialise() -> [AnyObject]{
        return [self.sensorType.rawValue as AnyObject, self.updateIntervallHz as AnyObject] as [AnyObject]
    }
}

internal extension HeartRateSensorSettings{
    internal func serialise() -> [AnyObject]{
        return [self.sensorType.rawValue as AnyObject] as [AnyObject]
    }
}

internal class SensorSettingFactory{
    
    private static func deserialiseSettings(fromData data: [AnyObject]) -> SensorSettings?{
        let rawType = data[0] as! Int
        let type = AWSSensorType(rawValue: rawType)!
        
        switch type {
        case .accelerometer:
            let updateIntervall : Double = data[1] as! Double
            return RawAccelerometerSensorSettings(withIntervall_Hz: updateIntervall)
        case .device_motion:
            let updateIntervall : Double = data[1] as! Double
            return DeviceMotionSensorSettings(withIntervall_Hz: updateIntervall)
        case .heart_rate:
            return HeartRateSensorSettings()
        default:
            return nil
        }
        
    }
    
    internal static func deserialiseSettingsSet(data: [[AnyObject]]) -> [SensorSettings]{
        var settings = [SensorSettings]()
        
        for d in data{
            settings.append(deserialiseSettings(fromData: d)!)
        }
        
        return settings
    }
    
    internal static func serialiseSettingsSet(settings: [SensorSettings]) -> [[AnyObject]]{
        var data = [[AnyObject]]()
        
        for s in settings{
            switch s.sensorType {
            case .accelerometer:
                data.append((s as! RawAccelerometerSensorSettings).serialise())
            case .device_motion:
                data.append((s as! DeviceMotionSensorSettings).serialise())
            case .heart_rate:
                data.append((s as! HeartRateSensorSettings).serialise())
            default: break
            }
        }
        
        return data
    }
}
