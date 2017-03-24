//
//  SensingConfiguration.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 02/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation

public class SensingConfiguration{
    
    public private(set) var enabledSensors : Set<AWSSensorType> = Set<AWSSensorType>()
    
    public private(set) var sensorSettings : [AWSSensorType: SensorSettings] = [AWSSensorType: SensorSettings]()
    
    public init(withEnabledSensors sensors:[AWSSensorType], sensorSettings settings: [SensorSettings]?) {
        for s: AWSSensorType in sensors {
            self.enableSensor(withType: s)
        }
        if(settings != nil){
            for s: SensorSettings in settings!{
                if(enabledSensors.contains(s.sensorType)){
                    sensorSettings[s.sensorType] = s
                }
            }
        }
    }
    
    public func getSensorArray() -> [AWSSensorType]{
        return Array(enabledSensors)
    }
    
    internal func enableSensor(withType type : AWSSensorType, settings: SensorSettings? = nil){
        enabledSensors.insert(type)
    }
 
    internal func disableSensor(withType type : AWSSensorType, settings: SensorSettings? = nil){
        enabledSensors.remove(type)
    }
}
