//
//  SensingSession.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 03/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation

public class SensingSession{
    
    
    // MARK: - properties
    
    public internal(set) var state : SensingSessionState
    
    public private(set) var sensorConfig : SensingConfiguration
    public private(set) var transmissionIntervall : DataTransmissionInterval
    
    // MARK: - init
    
    init(enabledSensors sensors: [AWSSensorType], sensorSettings settings: [SensorSettings], transmissionIntervall intervall: DataTransmissionInterval = DataTransmissionInterval.standard){
        state = .created

        sensorConfig = SensingConfiguration(withEnabledSensors: sensors, sensorSettings: settings)

        self.transmissionIntervall = intervall
    }
    
    init(withConfiguration configuration : SensingConfiguration, transmissionIntervall intervall: DataTransmissionInterval = DataTransmissionInterval.standard){
        state = .created
        
        sensorConfig = configuration
        
        self.transmissionIntervall = intervall
    }

    
//    init(enabledSensorSet sensors: Set<AWSSensorType>, transmissionIntervall intervall: DataTransmissionInterval = DataTransmissionInterval.standard){
//        state = .created
//        
//        sensorConfig = SensingConfiguration()
//        sensorConfig.enabledSensors = sensors
//
//        self.transmissionIntervall = intervall
//    }
    
    
    // MARK: - methods
    
    internal func reset(configuration: SensingConfiguration){
        sensorConfig = configuration
    }
    
    internal func reset(transmissionIntervall intervall: DataTransmissionInterval){
        transmissionIntervall = intervall
    }
}

public enum SensingSessionState : String{
    case created
    case running
    case terminated
}
