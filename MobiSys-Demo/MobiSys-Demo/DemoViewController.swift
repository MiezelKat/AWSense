//
//  ViewController.swift
//  MobiSys-Demo
//
//  Created by Katrin Haensel on 30/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import UIKit

import AWSenseConnectPhone

import HealthKit

class DemoViewController: UIViewController, RemoteSensingEventHandler {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    let sessionManager = SessionManager.instance
    
//    @IBOutlet weak var heartRateLabel: UILabel!
    
    @IBOutlet weak var graphView: GraphView! // CircleClosing!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sessionManager.subscribe(handler: self)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startPressed(_ sender: Any) {

        
        var healthStore = HKHealthStore()
        
        let dataTypes = Set(arrayLiteral: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!)
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) {
            success, error in
            // handle the result of the authorization
        }
        
        //disableStartSessionElements()
        
        var enabledSensors : [AWSSensorType] = [.heart_rate, .accelerometer]

        
        let transmissionIntervall = DataTransmissionInterval(0.35)
        
        do {
            // TODO: test sensor settings
            try sessionManager.startSensingSession(withName: "test", configuration: enabledSensors, sensorSettings: [RawAccelerometerSensorSettings(withIntervall_Hz: 3)], transmissionIntervall: transmissionIntervall)
            
            // DeviceMotionSensorSettings(withIntervall_Hz: 5)
        }catch let error as Error{
            print(error)
        }
        
        
    }

    @IBAction func stopPressed(_ sender: Any) {
        do {
            // TODO: test sensor settings
            try sessionManager.stopSensing()
        }catch let error as Error{
            print(error)
        }
    }
    
    public func handle(withType type: RemoteSensingEventType, forSession session: RemoteSensingSession?, withData data: [AWSSensorData]?) {
        if(type == .sessionCreated){
            self.statusLabel.text = "session created"
        }else if(type == .sessionStateChanged){
            DispatchQueue.main.async {
                self.statusLabel.text = session!.state.rawValue
            }
        }else if(type == .remoteSessionDataReceived){
            if(data!.count < 1){
                return
            }
            
            if(data![0].sensorType == .heart_rate){
//                DispatchQueue.main.async {
//                    self.heartRateLabel.text = data!.last!.prettyPrint
//                }
            }else if(data![0].sensorType == .accelerometer){
                let aData = data as! [AWSRawAccelerometerSensorData]
                let element = aData.last!
                DispatchQueue.main.async {
                    self.graphView.set(x: element.acceleration.x, y: element.acceleration.y, z: element.acceleration.z)
                }
            }
//            else if(data![0].sensorType == .device_motion){
////                let aData = data as! [AWSDeviceMotionSensorData]
////                let element = aData.last!
////                //DispatchQueue.main.async {
////                self.graphView.set(x: element.gravity.x, y: element.gravity.y, z: element.gravity.z)
//            }
        }
    }
    
}

