//
//  InterfaceController.swift
//  AWSenseConnectTest WatchKit Extension
//
//  Created by Katrin Haensel on 22/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import WatchKit
import Foundation

import AWSenseShared
import AWSenseWatch
import AWSenseConnectWatch


class InterfaceController: WKInterfaceController, SensingEventHandler{
   
    @IBOutlet var stateLabel: WKInterfaceLabel!
    
    let sessionManager : SensingSessionManager = SensingSessionManager.instance
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        sessionManager.subscribe(handler: self)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    public func handle(withType type: SensingEventType, forSession session: SensingSession) {
        DispatchQueue.main.async {
            if(type == .sessionCreated){
                self.stateLabel.setText("created")
            }else if( type == .sessionStateChanged){
                self.stateLabel.setText(session.state.rawValue)
            }
        }
    }


}
