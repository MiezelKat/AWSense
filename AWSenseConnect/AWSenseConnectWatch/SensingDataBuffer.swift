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
    
    private let bufferLimit = 1024 * 10
    
    // MARK: - properties
    
    var sensingSession : SensingSession
    
    var sensingBuffers : [AWSSensorType : [AWSSensorData]]
    
    var sensingBufferEvent : SensingBufferEvent = SensingBufferEvent()
    
    // MARK: - init
    
    init(withSession session : SensingSession){
        sensingSession = session
        sensingBuffers = [AWSSensorType : [AWSSensorData]]()
        for s : AWSSensorType in sensingSession.sensorConfig.enabledSensors{
            sensingBuffers[s] = [AWSSensorData]()
        }
    }
    
    
    // MARK: - methods
    
    func append(sensingData data: AWSSensorData, forType type: AWSSensorType){
        //sync (array: sensingBuffers[type]!) {
            sensingBuffers[type]?.append(data)
//        }
        if(sensingBuffers[type]!.count > bufferLimit){
            self.sensingBufferEvent.raiseEvent(withType: .bufferLimitReached, forSensor: type)
        }
    }
    
    func prepareFileToSend(forType type: AWSSensorType) -> URL{
        let url = serialise(forType: type)
        // reset the buffer
//        sync (array: sensingBuffers[type]!) {
            sensingBuffers[type]!.removeAll(keepingCapacity: true)
//        }
        return url!
    }

//    private func sync(array: [AWSSensorData], closure: () -> Void) {
//        objc_sync_enter(array)
//        closure()
//        objc_sync_exit(array)
//    }
    
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
