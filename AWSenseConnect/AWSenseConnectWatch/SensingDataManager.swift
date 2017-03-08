//
//  SensingDataManager.swift
//  AWSenseConnect
//
//  Created by Katrin Hansel on 05/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared

internal class SensingDataManager : SensingBufferEventHandler {
    

    // MARK: - singleton
    
    internal static let instance : SensingDataManager = SensingDataManager()
    
    private init(){
        
    }
    
    
    // MARK: - properties

    
    var sensingDataBuffer : SensingDataBuffer?
    
    var sensingSession : SensingSession? {
        return SensingSessionManager.instance.currentSession
    }
    
    var transmissionMode : DataTransmissionMode?{
        return SensingSessionManager.instance.currentSession?.transmissionMode
    }
    
    var lastTransmissions : [AWSSensorType : Date] = [AWSSensorType : Date]()
    
    // MARK: - methods
    
    func initialise(withSession session: SensingSession){
        if(session.transmissionMode == .batch){
            sensingDataBuffer = SensingDataBuffer(withSession: session)
        }else if(session.transmissionMode == .stream){
            sensingDataBuffer = SensingDataBuffer(withSession: session)
            
            let now = Date()
            for type in session.sensorConfig.enabledSensors{
                lastTransmissions[type] = now
            }
        }
    }
    
    func manage(sensingData data : AWSSensorData, forType type: AWSSensorType){
        if(transmissionMode! == .batch){
            sensingDataBuffer!.append(sensingData: data, forType: type)
        }else if(transmissionMode! == .stream){
            let refDate = Date().addingTimeInterval(-2)
            sensingDataBuffer!.append(sensingData: data, forType: type)
            if(lastTransmissions[type]!.compare(refDate) == .orderedAscending){
                lastTransmissions[type] = Date()
                let data = sensingDataBuffer?.prepareDataToSend(forType: type)
                let message = SensingDataMessage(withSensingData: data!, ofType: type)
                CommunicationManager.instance.send(message: message)
            }
        }
    }
    
    func sessionStopped(){
        if(transmissionMode! == .batch && sensingDataBuffer != nil){
            sensingDataBuffer!.clearAllBuffers()
        }
    }
    
    // MARK: - SensingBufferEventHandler

    func handle(withType type: SensingBufferEventType, forSensor stype: AWSSensorType){
        if(type == .bufferLimitReached && sensingDataBuffer != nil){
            let data = sensingDataBuffer!.prepareDataToSend(forType: stype)
            let message = SensingDataMessage(withSensingData: data, ofType: stype)
            CommunicationManager.instance.send(message: message)
        }
    }

}





