//
//  Messages.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 02/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared

internal enum MessageType : Int {
    case startSensing
    case stopSensing
    case sensingData
    case sensingDataSample
    case startedSensing
    case stoppedSensing
    case undefined
    
    static let typeKey : String = "m_type"
}

internal protocol Message{
    
    static var type : MessageType{
        get
    }
    
    var type : MessageType{
        get
    }
    
    
    func createPayload() -> [String : Any]
    
    init(fromPayload payload : [String : Any])

}

internal class MessageParser{
    
    internal static func parseMessage(fromPayload payload: [String : Any]) -> Message?{
        let type : MessageType = MessageType(rawValue: payload[MessageType.typeKey] as! Int)!
        
        switch type {
        case .startSensing:
            return StartSensingMessage(fromPayload: payload)
        case .stopSensing:
            return StopSensingMessage(fromPayload: payload)
        case .sensingData:
            return SensingFileMessage(fromPayload: payload)
        case .sensingDataSample:
            return SensingSampleMessage(fromPayload: payload)
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

internal class AbstractMessage : Message{
    
    /// message type
    internal class var type: MessageType {
        return .undefined
    }
    
    internal var type: MessageType{
        return type(of: self).type
    }
    
    private static let timestampKey = "ts"
    internal private(set) var timestamp : Date
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    internal required init(fromPayload payload: [String : Any]) {
        timestamp = payload[type(of: self).timestampKey] as! Date
    }
    
    internal init() {
        timestamp = Date()
    }
    
    
    /// Create a payload dictionary
    ///
    /// - Returns: the payload
    internal func createPayload() -> [String : Any] {
        var payload : [String : Any] = [String : Any]()
        payload[type(of: self).timestampKey] = timestamp
        payload[MessageType.typeKey] = type(of: self).type.rawValue
        return payload
    }
    
}

//internal class SensingDataMessage : AbstractMessage{
//    
//    /// message type
//    internal override class var type: MessageType {
//        return .sensingData
//    }
//    
//    private static let sensingDataKey = "data"
//    internal private(set) var sensingData : [AWSSensorData]
//    
//    private static let sensingDataTypeKey = "sd_type"
//    internal private(set) var sensingDataType : AWSSensorType
//    
//    
//    /// Parse a configuration message from the payload
//    ///
//    /// - Parameter payload: dictionary of values
//    internal required init(fromPayload payload: [String : Any]) {
//        
//        sensingDataType = AWSSensorType(rawValue: payload[type(of: self).sensingDataTypeKey] as! Int)!
//        
//        let dataArr : [[AnyObject]] = payload[type(of: self).sensingDataKey] as! [[AnyObject]]
//
//        // TODO: That is quite ugly: Improve!
//        sensingData = [AWSSensorData]()
//        
//        super.init(fromPayload: payload)
//        sensingData = dataArr.map{ e in
//            return AWSSensorDataParser.parse(fromData: e, forType: sensingDataType)!
//        }
//    }
//    
//    /// Initialise with sensing data
//    ///
//    /// - Parameter data: data array
//    /// - Parameter type: type of the sensor
//    internal init(withSensingData data: [AWSSensorData], ofType type: AWSSensorType){
//        self.sensingDataType = type
//        self.sensingData = data
//        super.init()
//    }
//    
//    /// Create a payload dictionary
//    ///
//    /// - Returns: the payload
//    internal override func createPayload() -> [String : Any] {
//        var payload = super.createPayload()
//        payload[type(of: self).sensingDataTypeKey] = sensingDataType.rawValue
//        payload[type(of: self).sensingDataKey] = sensingData.map{ e in
//            return e.data
//        }
//        //dump(payload)
//        return payload
//    }
//    
//}

internal class SensingFileMessage : AbstractMessage{
    
    /// message type
    internal override class var type: MessageType {
        return .sensingData
    }
    
    internal var sensingFile : URL?
    
    private static let sensingDataTypeKey = "sd_type"
    internal private(set) var sensingDataType : AWSSensorType
    
    private static let batchNoKey = "batch_no"
    internal private(set) var batchNo : Int
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    internal required init(fromPayload payload: [String : Any]) {
        sensingDataType = AWSSensorType(rawValue: payload[type(of: self).sensingDataTypeKey] as! Int)!
        batchNo = payload[type(of: self).batchNoKey] as! Int
        super.init()
    }
    
    /// Initialise with sensing data
    ///
    /// - Parameter data: data array
    /// - Parameter type: type of the sensor
    internal init(withURL url: URL, ofType type: AWSSensorType, batchNo : Int = 1){
        self.sensingFile = url
        self.sensingDataType = type
        self.batchNo = batchNo
        super.init()
    }
    
    /// Create a payload dictionary
    ///
    /// - Returns: the payload
    internal override func createPayload() -> [String : Any] {
        var payload = super.createPayload()
        payload[type(of: self).sensingDataTypeKey] = sensingDataType.rawValue
        payload[type(of: self).batchNoKey] = batchNo
        return payload
    }
    
}


internal class SensingSampleMessage : AbstractMessage{
    
    /// message type
    internal override class var type: MessageType {
        return .sensingDataSample
    }
    
    private static let sensorDataKey = "data"
    internal private(set) var sensorData : AWSSensorData
    
    private static let sensorDataTypeKey = "sd_type"
    internal private(set) var sensorDataType : AWSSensorType
    
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    internal required init(fromPayload payload: [String : Any]) {
        
        sensorDataType = AWSSensorType(rawValue: payload[type(of: self).sensorDataTypeKey] as! Int)!
        
        let dataArr : [AnyObject] = payload[type(of: self).sensorDataKey] as! [AnyObject]
        
        // TODO: That is quite ugly: Improve!
        sensorData = AWSSensorDataParser.parse(fromData: dataArr, forType: sensorDataType)!
        
        super.init(fromPayload: payload)

    }
    
    /// Initialise with sensing data
    ///
    /// - Parameter data: data array
    /// - Parameter type: type of the sensor
    internal init(withSensorData data: AWSSensorData, ofType type: AWSSensorType){
        self.sensorDataType = type
        self.sensorData = data
        super.init()
    }
    
    /// Create a payload dictionary
    ///
    /// - Returns: the payload
    internal override func createPayload() -> [String : Any] {
        var payload = super.createPayload()
        payload[type(of: self).sensorDataTypeKey] = sensorDataType.rawValue
        payload[type(of: self).sensorDataKey] = sensorData.data
        //dump(payload)
        return payload
    }
    
}



internal class StopSensingMessage : AbstractMessage{
    
    /// message type
    internal override class var type: MessageType {
        return .stopSensing
    }
    
    internal override init() {
        super.init()
    }
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    internal required init(fromPayload payload: [String : Any]) {
        super.init(fromPayload: payload)
    }
    
}


internal class StartSensingMessage : AbstractMessage{
    
    /// message type
    internal override class var type: MessageType {
        return .startSensing
    }
    
    private static let configurationKey = "config"
    internal private(set) var configuration : SensingConfiguration
    
    private static let transmissionModeKey = "transmission"
    internal private(set) var transmissionIntervall : DataTransmissionInterval
    
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    internal required init(fromPayload payload: [String : Any]) {
        let sensArr = payload[type(of: self).configurationKey] as! [Int]
        let s = sensArr.map{ sens in
            return AWSSensorType(rawValue: sens)
        } as! [AWSSensorType]
        configuration = SensingConfiguration(withEnabledSensors: s)
        transmissionIntervall = DataTransmissionInterval(payload[type(of: self).transmissionModeKey] as! Double)
        // DataTransmissionMode(rawValue: payload[type(of: self).transmissionModeKey] as! String)
        super.init(fromPayload: payload)
    }
    
    
    /// Create with a configuration
    ///
    /// - Parameter config: configuration
    internal init(withConfiguration config: SensingConfiguration, transmisssionIntervall intervall: DataTransmissionInterval){
        self.configuration = config
        self.transmissionIntervall = intervall
        super.init()
    }
    
    /// Create a payload dictionary
    ///
    /// - Returns: the payload
    internal override func createPayload() -> [String : Any] {
        var payload = super.createPayload()
        let configPayload = configuration.getSensorArray().map{ s in
            return s.rawValue
        }
        payload[type(of: self).configurationKey] = configPayload
        payload[type(of: self).transmissionModeKey] = transmissionIntervall.intervallSeconds
        return payload
    }

}


internal class StartedSensingMessage : AbstractMessage{
    
    /// message type
    internal override class var type: MessageType {
        return .startedSensing
    }
    
    private static let startTimeKey = "startTime"
    internal private(set) var startTime : Date
    
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    internal required init(fromPayload payload: [String : Any]) {
        startTime = payload[type(of: self).startTimeKey] as! Date
        super.init(fromPayload: payload)
    }
    
    /// Init with a start data when sensing began
    ///
    /// - Parameter startDate: start date of sensing
    internal init(withStartDate startDate: Date){
        self.startTime = startDate
        super.init()
    }
    
    /// Create a payload dictionary
    ///
    /// - Returns: the payload
    internal override func createPayload() -> [String : Any] {
        var payload = super.createPayload()
        payload[type(of: self).startTimeKey] = startTime
        return payload
    }
    
}


internal class StoppedSensingMessage : AbstractMessage{
    
    /// message type
    internal override class var type: MessageType {
        return .stoppedSensing
    }
    
    private static let stopTimeKey = "endTime"
    internal private(set) var stopTime : Date
    
    
    /// Parse a configuration message from the payload
    ///
    /// - Parameter payload: dictionary of values
    internal required init(fromPayload payload: [String : Any]) {
        stopTime = payload[type(of: self).stopTimeKey] as! Date
        super.init(fromPayload: payload)
    }
    
    /// Init with a start data when sensing began
    ///
    /// - Parameter startDate: start date of sensing
    internal init(withStopDate stopDate: Date){
        self.stopTime = stopDate
        super.init()
    }
    
    /// Create a payload dictionary
    ///
    /// - Returns: the payload
    internal override func createPayload() -> [String : Any] {
        var payload = super.createPayload()
        payload[type(of: self).stopTimeKey] = stopTime
        return payload
    }
    
}
