//
//  Messages.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 02/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseWatch

public enum MessageType : Int {
    case configuration
    case startSensing
    case stopSensing
    case sensingData
    case startedSensing
    case stoppedSensing
    case undefined
    
    static let typeKey : String = "type"
}

public protocol Message{
    
    static var type : MessageType{
        get
    }
    
    func createPayload() -> [String : Any]
    
    init(fromPayload payload : [String : Any])
    

    
}

internal class MessageParser{
    
    static func parseMessage(fromPayload payload: [String : Any]) -> Message?{
        let type : MessageType = MessageType(rawValue: payload[MessageType.typeKey] as! Int)!
        
        switch type {
        case .configuration:
            return ConfigurationMessage(fromPayload: payload)
        case .startSensing:
            return StartSensingMessage(fromPayload: payload)
        case .stopSensing:
            return StopSensingMessage(fromPayload: payload)
        case .sensingData:
            return SensingDataMessage(fromPayload: payload)
        case .startedSensing:
            return StartedSensingMessage(fromPayload: payload)
        case .stoppedSensing:
            return StoppedSensingMessage(fromPayload: payload)
        default:
            print("wrong payload message type")
            return nil
        }
    }
    
}

public class AbstractMessage : Message{
    
    /// message type
    public class var type: MessageType {
        return .undefined
    }
    
    private static let timestampKey = "ts"
    public internal(set) var timestamp : Date
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    public required init(fromPayload payload: [String : Any]) {
        timestamp = payload[type(of: self).timestampKey] as! Date
    }
    
    
    /// Create a payload dictionary
    ///
    /// - Returns: the payload
    public func createPayload() -> [String : Any] {
        var payload : [String : Any] = [String : Any]()
        payload[type(of: self).timestampKey] = timestamp
        payload[MessageType.typeKey] = type(of: self).type
        return payload
    }
    
}

public class ConfigurationMessage : AbstractMessage{
    
    /// message type
    public override class var type: MessageType {
        return .configuration
    }
    
    private static let configurationKey = "config"
    public internal(set) var configuration : SensingConfiguration
    
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    public required init(fromPayload payload: [String : Any]) {
        configuration = payload[type(of: self).configurationKey] as! SensingConfiguration
        super.init(fromPayload: payload)
    }
    
    
    /// Create a payload dictionary
    ///
    /// - Returns: the payload
    public override func createPayload() -> [String : Any] {
        var payload = super.createPayload()
        payload[type(of: self).configurationKey] = configuration
        return payload
    }
    
}

public class SensingDataMessage : AbstractMessage{
    
    /// message type
    public override class var type: MessageType {
        return .sensingData
    }
    
    private static let sensingDataKey = "data"
    public internal(set) var sensingData : [AWSSensorData]
    
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    public required init(fromPayload payload: [String : Any]) {
        sensingData = payload[type(of: self).sensingDataKey] as! [AWSSensorData]
        super.init(fromPayload: payload)
    }
    
    
    /// Create a payload dictionary
    ///
    /// - Returns: the payload
    public override func createPayload() -> [String : Any] {
        var payload = super.createPayload()
        payload[type(of: self).sensingDataKey] = sensingData
        return payload
    }
    
}


public class StopSensingMessage : AbstractMessage{
    
    /// message type
    public override class var type: MessageType {
        return .stopSensing
    }
    
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    public required init(fromPayload payload: [String : Any]) {
        super.init(fromPayload: payload)
    }
    
    
    /// Create a payload dictionary
    ///
    /// - Returns: the payload
    public override func createPayload() -> [String : Any] {
        var payload = super.createPayload()

        return payload
    }
    
}


public class StartSensingMessage : AbstractMessage{
    
    /// message type
    public override class var type: MessageType {
        return .startSensing
    }
    
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    public required init(fromPayload payload: [String : Any]) {
        super.init(fromPayload: payload)
    }
    
    
    /// Create a payload dictionary
    ///
    /// - Returns: the payload
    public override func createPayload() -> [String : Any] {
        var payload = super.createPayload()
        
        return payload
    }
}


public class StartedSensingMessage : AbstractMessage{
    
    /// message type
    public override class var type: MessageType {
        return .startedSensing
    }
    
    private static let startTimeKey = "startTime"
    public internal(set) var startTime : Date
    
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    public required init(fromPayload payload: [String : Any]) {
        startTime = payload[type(of: self).startTimeKey] as! Date
        super.init(fromPayload: payload)
    }
    
    
    /// Create a payload dictionary
    ///
    /// - Returns: the payload
    public override func createPayload() -> [String : Any] {
        var payload = super.createPayload()
        payload[type(of: self).startTimeKey] = startTime
        return payload
    }
    
}


public class StoppedSensingMessage : AbstractMessage{
    
    /// message type
    public override class var type: MessageType {
        return .stoppedSensing
    }
    
    private static let stopTimeKey = "endTime"
    public internal(set) var stopTime : Date
    
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    public required init(fromPayload payload: [String : Any]) {
        stopTime = payload[type(of: self).stopTimeKey] as! Date
        super.init(fromPayload: payload)
    }
    
    
    /// Create a payload dictionary
    ///
    /// - Returns: the payload
    public override func createPayload() -> [String : Any] {
        var payload = super.createPayload()
        payload[type(of: self).stopTimeKey] = stopTime
        return payload
    }
    
}
