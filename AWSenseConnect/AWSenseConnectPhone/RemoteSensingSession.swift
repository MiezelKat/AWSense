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
    public private(set) var transmissionMode : DataTransmissionMode
    
    // MARK: - init
    
    init(withName name: String? = nil, enabledSensors sensors: [AWSSensorType]? = nil, transmissionMode: DataTransmissionMode = .batch){
        state = .created
        if(sensors != nil){
            sensorConfig = SensingConfiguration(withEnabledSensors: sensors!)
        }else{
            sensorConfig = SensingConfiguration()
        }
        id = UUID().uuidString
        self.name = name
        self.transmissionMode = transmissionMode
    }

    
    // MARK: - methods
    
    internal func resetConfig(enabledSensors sensors: [AWSSensorType]){
        sensorConfig = SensingConfiguration(withEnabledSensors: sensors)
    }
    
    internal func reset(transmissionMode mode: DataTransmissionMode){
        transmissionMode = mode
    }
}

public enum RemoteSensingSessionState{
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
