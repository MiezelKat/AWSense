//
//  SensingSession.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 03/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared

public class SensingSession{
    
    
    // MARK: - properties
    
    public internal(set) var state : SensingSessionState
    
    public private(set) var sensorConfig : SensingConfiguration
    public private(set) var transmissionMode : DataTransmissionMode
    
    // MARK: - init
    
    init(enabledSensors sensors: [AWSSensorType]? = nil, transmissionMode: DataTransmissionMode = .batch){
        state = .created
        if(sensors != nil){
            sensorConfig = SensingConfiguration(withEnabledSensors: sensors!)
        }else{
            sensorConfig = SensingConfiguration()
        }
        self.transmissionMode = transmissionMode
    }
    
    
    // MARK: - methods
    
    internal func reset(configuration: SensingConfiguration){
        sensorConfig = configuration
    }
    
    internal func reset(transmissionMode mode: DataTransmissionMode){
        transmissionMode = mode
    }
}

public enum SensingSessionState{
    case created
    case running
    case terminated
    
}
