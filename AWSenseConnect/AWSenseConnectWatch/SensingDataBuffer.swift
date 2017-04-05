//
//  SensingDataBuffer.swift
//  AWSenseConnect
//
//  Created by Katrin Hansel on 05/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared

internal class SensingDataBuffer{
    
    private let bufferLimit = 1024
    
    private let bufferLimitHR = 10
    
    // MARK: - properties
    
    var sensingSession : SensingSession
    
    var sensingBuffers : [AWSSensorType : [AWSSensorData]]
    var sensingBufferBatchNo : [AWSSensorType : Int]
    
    var sensingBufferEvent : SensingBufferEvent = SensingBufferEvent()
    
    // MARK: - init
    
    init(withSession session : SensingSession){
        sensingSession = session
        sensingBuffers = [AWSSensorType : [AWSSensorData]]()
        sensingBufferBatchNo = [AWSSensorType : Int]()
        for s : AWSSensorType in sensingSession.sensorConfig.enabledSensors{
            sensingBuffers[s] = [AWSSensorData]()
            sensingBufferBatchNo[s] = 1
        }
    }
    
    
    // MARK: - methods
    
    func append(sensingData data: AWSSensorData, forType type: AWSSensorType){
        let count = sensingBuffers[type]!.count
        sensingBuffers[type]!.append(data)
        
        if(type != .heart_rate && count > bufferLimit){
            if(type == .device_motion){
                print("devide motion")
            }
            sensingBufferEvent.raiseEvent(withType: .bufferLimitReached, forSensor: type)
        }else if (type == .heart_rate && count > bufferLimitHR){
            sensingBufferEvent.raiseEvent(withType: .bufferLimitReached, forSensor: type)
        }
    }
    
    func prepareDataToSend(forType type: AWSSensorType) -> (Int, [AWSSensorData]){
        let batchNo = sensingBufferBatchNo[type]!
        let data = sensingBuffers[type]!
        // reset the buffer
        sensingBuffers[type]!.removeAll(keepingCapacity: true)
        
        return (batchNo, data)
    }
    
    public func subscribe(handler: SensingBufferEventHandler){
        sensingBufferEvent.add(handler: handler)
    }
    
    public func unsubscribe(handler: SensingBufferEventHandler){
        sensingBufferEvent.remove(handler: handler)
    }
}

class SensingBufferEvent{
    
    private var eventHandlers = [SensingBufferEventHandler]()
    
    public func raiseEvent(withType type: SensingBufferEventType, forSensor stype : AWSSensorType) {
        for handler in self.eventHandlers {
            handler.handle(withType: type, forSensor: stype)
        }
    }
    
    public func add(handler: SensingBufferEventHandler){
        eventHandlers.append(handler)
    }
    
    public func remove(handler: SensingBufferEventHandler){
        eventHandlers = eventHandlers.filter { $0 !== handler }
    }
}

protocol SensingBufferEventHandler : class {
    
    func handle(withType type: SensingBufferEventType, forSensor stype: AWSSensorType)
    
}

enum SensingBufferEventType{
    case bufferLimitReached
}
