# AWSense
This library provides basic sensing functionality for the Apple Watch. 

At the moment, it allows easy access to the following sensors from within a Watchkit App:
* Heart rate
* Raw Accelerometer
* Device Motion:
  * Gyroscope
  * Linear Accelerometer
  * Gravity
  * Attitude

AWSense is separated in two parts:
* AWSense Core: The Core is a standalone library for the Apple Watch which can be incorperated in Apple Watch apps for eased access to sensing data. It does not provice functionalities to transfer the sensing data to the phone.
* AWSense Connect: This framework builds on top of the AWSence Core and provides communication functionalities for session management and data transmission. 

This schematic highlights the architecture of the AWSense framework:

![schematics of architecture](https://github.com/MiezelKat/AWSense/blob/working/schematics-small.png)

## AWSense Core

The AWSense Core provides functionality to ease the sensor access on the Apple Watch. 

### WatchKit App and Phone App Requirements

Your WatchKit App needs the following requirements:
* HealthKit entitlement and Heart Rate has to be enabled as a HealthKit source
* If the sensing should continue in the background, your app needs to allow workout processing as background mode
* The WatchKit App has to link the *AWSenseShared* and *AWSenseWatch* targets

Although, the sensing takes place and the watch and not data is transmitted to the phone, the Phone App needs the following requirements:
* HealthKit entitlement and Heart Rate has to be enabled as a HealthKit source
* The Motion Usage Description has to be added to the app's Info.plist to allow access of motion sensors on the watch

(Have a look in our Wiki on how to setup your app for those things)

### Subscribing to Sensor Events in the Watch App

Withing your WatchKit app, the class handeling sensor events has to be conform to the `AWSSensorEventHandler` protocol. 

This event handler is subscribed to the sensors via the `AWSSensorManager` singleton:

``` Swift
let manager = AWSSensorManager.sharedInstance
        
if(sensors![.heart_rate]! && manager.isSensorAvailable(sensor: .heart_rate)){
  manager.register(eventhandler: self, with: .heart_rate)
  manager.startSensing(with: .heart_rate)
}
```

## AWSense Connect

AWSense Connect builds on top of the AWSense Core and provides functionality to ease wearable sensing sessions managed by the phone.  

### WatchKit App and Phone App Requirements

Your WatchKit App needs the following requirements:
* HealthKit entitlement and Heart Rate has to be enabled as a HealthKit source
* For continuous sensing and data transmission, your app needs to allow workout processing as background mode
* The WatchKit App has to link the *AWSenseShared*, *AWSenseWatch* and *AWSenseConnectWatch* targets

Your Phone App needs the following requirements:
* HealthKit entitlement and Heart Rate has to be enabled as a HealthKit source
* The Motion Usage Description has to be added to the app's Info.plist to allow access of motion sensors on the watch
* The Phone App has to link the *AWSenseShared* and *AWSenseConnectPhone* targets

(Have a look in our Wiki on how to setup your app for those things)

### Watch App

Withing your WatchKit app, the class handeling the sensing session events has to be conform to the `SensingEventHandler` protocol. 

This event handler is subscribed to the sensors via the `SensingSessionManager` singleton:

``` Swift
SensingSessionManager.instance.subscribe(handler: self)
```

Even though you do ignore those events in your WatchKit App, this step is nessecary to internally initialise the required fuctionalities.

### Phone App

Withing your Phone app, the class handeling sensor events has to be conform to the `RemoteSensingEventHandler` protocol. 

This event handler is subscribed to the sensors via the `SessionManager` singleton:

``` Swift
let manager = SessionManager.sharedInstance
        
do {
    try sessionManager.startSensingSession(withName: "test_session", 
                                           configuration: [.heart_rate, .accelerometer], 
                                           sensorSettings: [RawAccelerometerSensorSettings(withIntervall_Hz: 1.0)])
            
}catch let error as Error{
    print(error)
}
```


