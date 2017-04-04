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

### Setup

To use the library, include it in your xCode project. Include the library in your WatchKit Extension target as embedded binary. 

To get sensor updates, follow these steps:

1. Include the library

`
import AWSenseWatch
`


