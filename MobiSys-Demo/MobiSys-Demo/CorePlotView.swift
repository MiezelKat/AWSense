//
//  CorePlotView.swift
//  MobiSys-Demo
//
//  Created by Katrin Haensel on 31/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import CorePlot
import UIKit

class CorePlotView : UIView, CPTScatterPlotDataSource{
    
    /** @brief @required The number of data points for the plot.
     *  @param plot The plot.
     *  @return The number of data points for the plot.
     **/
    public func numberOfRecords(for plot: CPTPlot) -> UInt {
        return 3
    }

    let dummyData : [Double] = [2.0, 1.0, 3.0]
    
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        return dummyData[Int(idx)] //fieldEnum == UInt(CPTScatterPlotField.X.rawValue) ? idx * 2 : dummyData[idx]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
//    func numbers(for plot: CPTPlot, field fieldEnum: UInt, recordIndexRange indexRange: NSRange) -> [Any]? {
//        <#code#>
//    }
    
//    func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> NSNumber! {
//        
//        if plot.identifier.description == "expected" {
//            var workoutLog =
//                self.userWorkout!.expectedWorkoutLogAtIndexOrLast(idx)
//            if workoutLog == nil {
//                return 0
//            }
//            
//            return (fieldEnum == UInt(CPTScatterPlotFieldX.value)
//                ? workoutLog!.elapsedTime : workoutLog!.bpm)
//            
//        } else { // actual
//            var workoutLog =self.userWorkout!.actualWorkoutLogAtIndexOrLast(idx)
//            if workoutLog == nil {
//                return 0
//            }
//            
//            return (fieldEnum == UInt(CPTScatterPlotFieldX.value)
//                ? workoutLog!.elapsedTime : workoutLog!.bpm)
//        }
//    }
    
    var graph = CPTXYGraph(frame: CGRect.zero)
    
    func setup(){
        
        let tts = CPTMutableTextStyle()
        tts.fontSize = 14.0
        tts.color = CPTColor(componentRed: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
        tts.fontName = "HelveticaNeue-Bold"
        self.graph.titleTextStyle = tts
        
        self.graph.title = "Heart Rate vs Time"
        self.graph.apply(CPTTheme(named:.stocksTheme))
        
        var plotSpace = graph.defaultPlotSpace!
        
        var plot = CPTScatterPlot(frame: self.bounds)
        plot.dataSource = self
        
        var actualPlotStyle = plot.dataLineStyle!.mutableCopy() as! CPTMutableLineStyle
        
        actualPlotStyle.lineWidth = 2.0
        actualPlotStyle.lineColor = CPTColor(cgColor: (UIColor.yellow.cgColor))
        plot.dataLineStyle = actualPlotStyle
        
        self.graph.add(plot)
        
    }
    
    
    
}
