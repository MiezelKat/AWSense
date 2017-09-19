//
//  WatchConnectivityManager
//  AWSenseConnect
//
//  Created by Katrin Haensel on 22/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import WatchConnectivity
import HealthKit


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
        session = WCSession.default
        
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
    
    
    func send(message: Message, urgent : Bool = true) {
        
        let payload = message.createPayload()
        
        if(session?.isReachable)!{
            session?.sendMessage(payload, replyHandler: nil, errorHandler: nil)
            print("message")
        }else if(session!.activationState == .activated){
            #if os(watchOS)
                session?.transferUserInfo(payload)
                print("user info")
            #elseif os(iOS)
                if(message.type == .startSensing){
                    // activate watch in background
                    if(session!.isWatchAppInstalled){
                        let store = HKHealthStore()
                        
                        let wConfig = HKWorkoutConfiguration()
                        wConfig.activityType = .other
                        wConfig.locationType = .unknown
                        
                        store.startWatchApp(with: wConfig, completion: { (success, error) in
                            // Handle errors
                            if(self.session?.isReachable)!{
                                self.session?.sendMessage(payload, replyHandler: nil, errorHandler: nil)
                            }else if(self.session!.activationState == .activated){
                                self.session?.transferUserInfo(payload)
                                print("user info")
                            }
                            
                            if(!success){
                                print("ERROR starting remote workout")
                                print(error!)
                            }
                            print("started remote workout \(self.session!.isReachable)")
                        })
                    }
                }else{
                    session?.transferUserInfo(payload)
                    print("user info")
                }
            #endif
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
