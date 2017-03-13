//
//  WatchConnectivityManager
//  AWSenseConnect
//
//  Created by Katrin Haensel on 22/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import WatchConnectivity


/// Commication Manager class
internal class CommunicationManager: NSObject, WCSessionDelegate {
    
    
    /// Singleton Instance
    static let instance = CommunicationManager()
    
    // MARK: - Properties
    
    var session : WCSession?
    
    private let messageEvent : MessageEvent = MessageEvent()
    
    // MARK: - Initialization
    
    /// Init
    private override init() {
        super.init()
        session = WCSession.default()
        
        session!.delegate = self
        session!.activate()
    }
    
    // MARK: - EventHandler
    
    
    func subscribe(handler: MessageEventHandler){
        messageEvent.add(handler: handler)
    }
    
    func unscribe(handler : MessageEventHandler){
        messageEvent.remove(handler: handler)
    }
    
    
    
    // Mark: - Send Messages
    
    
    func send(message: Message, userInfo : Bool = false) {
        
        let payload = message.createPayload()
        if(message.type == .sensingData){
            let m = message as! SensingFileMessage
            session?.transferFile(m.sensingFile!, metadata: payload)
        } else if(session!.isReachable && !userInfo){
            session?.sendMessage(payload, replyHandler: nil, errorHandler: nil)
        } else {
            session?.transferUserInfo(payload)
        }
    }
    
    func isReachable() -> Bool{
        return session!.isReachable
    }
  
    
    // MARK: - WCSessionDelegate Implementation Receive
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        let message = MessageParser.parseMessage(fromPayload: userInfo)
        messageEvent.raiseEvent(withMessage: message!)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let message = MessageParser.parseMessage(fromPayload: message)
        messageEvent.raiseEvent(withMessage: message!)
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let message = MessageParser.parseMessage(fromPayload: file.metadata!)!
        if(message.type == .sensingData){
            let m = message as! SensingFileMessage
            m.sensingFile = file.fileURL
        }
        messageEvent.raiseEvent(withMessage: message)
    }
    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
    #if os(watchOS)
        let url : URL = fileTransfer.file.fileURL
    #else
        let url : URL = fileTransfer.file.fileURL!
    #endif
        // TODO: put somewhere els if it works
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    // MARK: WCSessionDelegate - Activation
    
    // The next method is required in order to support asynchronous session activation as well as for quick watch switching.
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("session activation failed with error: \(error.localizedDescription)")
            return
        }
        
        print("session activated with state: \(activationState.rawValue)")
    }
    
    #if os(iOS)
    
    // those methods are just awailable on ios
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("session did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("session did deactivate")
        session.activate()
    }
    #endif
}
