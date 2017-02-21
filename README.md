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
  
In the future, I plan to include the following sensors:
* Ambient light
* Ambient noise levels

## Setup

To use the library, include it in your xCode project. Include the library in your WatchKit Extension target as embedded binary. 

To get sensor updates, follow these steps:

1. Include the library

`
import AWSenseWatch
`
