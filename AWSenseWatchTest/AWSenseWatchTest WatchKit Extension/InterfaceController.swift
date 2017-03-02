//
//  InterfaceController.swift
//  AWSenseWatchTest WatchKit Extension
//
//  Created by Katrin Hansel on 18/02/2017.
//  Copyright © 2017 QMUL. All rights reserved.
//

import WatchKit
import Foundation
import AWSenseWatch


class InterfaceController: WKInterfaceController, AWSSensorEventHandler {

    @IBOutlet var accelAvailableLabel: WKInterfaceLabel!
    
    @IBOutlet var hrAvailableLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let manager = AWSSensorManager.sharedInstance
        
        if(manager.isSensorAvailable(sensor: AWSSensorType.heart_rate)){
            manager.register(eventhandler: self, with: AWSSensorType.heart_rate)
            manager.startSensing(with: AWSSensorType.heart_rate)
        }
        
        // test 
        
        let fileName = "Tasks.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        
    }
    

    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func handleSensing(data: AWSSensorData, type: AWSSensorType) {
        if(type == AWSSensorType.accelerometer){
            DispatchQueue.main.async {
                self.accelAvailableLabel.setText(data.prettyPrint)
            }
        }else if(type == AWSSensorType.heart_rate){
            DispatchQueue.main.async {
                self.hrAvailableLabel.setText(data.prettyPrint)
            }
        }
    }


}
