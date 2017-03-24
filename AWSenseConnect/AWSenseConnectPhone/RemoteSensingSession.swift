//
//  RemoteSensingSession.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 03/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared

public class RemoteSensingSession{
    
    
    // MARK: - properties
    
    public private(set) var id : String
    public internal(set) var name : String?
    
    public internal(set) var state : RemoteSensingSessionState
    
    public private(set) var sensorConfig : SensingConfiguration
    public private(set) var transmissionIntervall : DataTransmissionInterval
    
    // MARK: - init
    
    init(withName name: String? = nil, enabledSensors sensors: [AWSSensorType], sensorSettings settings: [SensorSettings]?, transmissionIntervall intervall: DataTransmissionInterval = DataTransmissionInterval.standard){
        state = .created

        sensorConfig = SensingConfiguration(withEnabledSensors: sensors, sensorSettings: settings)

        id = UUID().uuidString
        self.name = name
        self.transmissionIntervall = intervall
    }

    
    // MARK: - methods
    
    internal func resetConfig(enabledSensors sensors: [AWSSensorType], sensorSettings settings: [SensorSettings]){
        sensorConfig = SensingConfiguration(withEnabledSensors: sensors, sensorSettings: settings)
    }
    
    internal func reset(transmissionIntervall intervall: DataTransmissionInterval){
        transmissionIntervall = intervall
    }
}

public enum RemoteSensingSessionState : String{
    case created
    case prepareRunning
    case running
    case prepareStopping
    case stopped
    case archived
    case undefined
}

public enum RemoteSensingSessionError : Error{
    case cannotCreateSession(reason: String)
    case cannotChangeSessionConfig(reason: String)
    case invalidSessionState(reason: String)
}
