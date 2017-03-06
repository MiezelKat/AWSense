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
    
    // MARK: - methods
    
    func initialise(withSession session: SensingSession){
        if(session.transmissionMode == .batch){
            sensingDataBuffer = SensingDataBuffer(withSession: session)
            
            
        }else if(session.transmissionMode == .stream){
            sensingDataBuffer = nil
        }
    }
    
    func manage(sensingData data : AWSSensorData, forType type: AWSSensorType){
        if(transmissionMode! == .batch){
            sensingDataBuffer!.append(sensingData: data, forType: type)
        }else if(transmissionMode! == .stream){
            let message = SensingDataMessage(withSensingData: [data], ofType: type)
            CommunicationManager.instance.send(message: message)
        }
    }
    
    func sessionStopped(){
        if(transmissionMode! == .batch && sensingDataBuffer != nil){
            sensingDataBuffer!.clearAllBuffers()
        }
    }
    
    // MARK: - SensingBufferEventHandler

    func handle(withType type: SensingBufferEventType, forSensor stype: AWSSensorType){
        if(type == .bufferLimitReached){
            let data = sensingDataBuffer?.prepareDataToSend(forType: stype)
            let message = SensingDataMessage(withSensingData: data!, ofType: stype)
            CommunicationManager.instance.send(message: message)
        }
    }

}





