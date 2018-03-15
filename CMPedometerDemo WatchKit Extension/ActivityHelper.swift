//
//  ActivityHelper.swift
//  CMPedometerDemoWatchApp Extension
//
//  Created by Tejas Ardeshna on 14/03/18.
//  Copyright © 2018 Simform Solutions PVT. LTD. All rights reserved.
//



import Foundation
import WatchKit
import CoreMotion
import Dispatch


let activityHelper = ActivityHelper.activityHelper
class ActivityHelper
{
    // static properties get lazy evaluation and dispatch_once_t for free
    struct Static {
        static let instance = ActivityHelper()
    }
    
    // this is the Swift way to do singletons
    class var activityHelper: ActivityHelper {
        return Static.instance
    }
    
    
    // MARK: - Variables
    fileprivate let pedometer                 = CMPedometer()
    fileprivate var startDate: Date?          = nil
    
    var timeElapsed:TimeInterval              = 1.0
    var numberOfSteps:Int!                    = 0
    var distance:Double!                      = 0.0
    var pace:Double!                          = 0.0
    var averagePace:Double!                   = 0.0
    var floorsAscended:Int!                   = 0
    var floorsDscended:Int!                   = 0
    var cadence:Double!                       = 0
    
    
    //MARK: - check pedometer availibility
    
    /// check if steps count is available in device or not
    var isStepCountingAvailable : Bool{
        get{
            return CMPedometer.isStepCountingAvailable()
        }
    }
    
    /// check if pace is available in device or not
    var isPaceAvailable : Bool{
        get{
            return CMPedometer.isPaceAvailable()
        }
    }
    
    /// check if distance is available in device or not
    var isDistanceAvailable : Bool{
        get{
            return CMPedometer.isDistanceAvailable()
        }
    }
    
    var isCadenceAvailable : Bool{
        get{
            return CMPedometer.isCadenceAvailable()
        }
    }
    
    /// check if floor count is available in device or not
    var isFloorCountingAvailable : Bool{
        get{
            return CMPedometer.isFloorCountingAvailable()
        }
    }
    
    // MARK: - blocks
    /// This block will return steps, distance, averagePage, pace, floor ascended, floor dscended
    public var stepsCountingHandler: ((_ steps: Int, _ distance: Double, _ averagePace : Double, _ pace : Double, _ floorsAscended : Int , _ floorsDscended : Int, _ cadence : Double, _ timeElapsed : Int ) -> Void)?
    
    
    
    init() {
        
    }
    
    
    /// start monitoring pedometer
    func stopMonitoring()
    {
        onStop()
    }
    
    /// stop monitoring pedometer
    func startMonitoring()
    {
        onStart()
    }
    
    
    /// start pedometer observer and set start date
    private func onStart() {
        startDate = Date()
         startUpdating()
        if checkAuthorizationStatus()
        {
            startUpdating()
        }
    }
    
    
    /// stop pedometer and nil start date
    private func onStop() {
        startDate = nil
        stopUpdating()
    }
    
    
    private func startUpdating() {
        if self.isStepCountingAvailable{
            startTrackingSteps()
        }
    }
    
    private func checkAuthorizationStatus() -> Bool{
        var pedoMeterAuthorized = false
        switch CMPedometer.authorizationStatus() {
            case .denied:
               break // onStop()
            case .authorized: pedoMeterAuthorized = true
            default: break
        }
        return pedoMeterAuthorized
    }
    
    private func stopUpdating() {
        stopPedometer()
    }

    /// Get historic data of pedometer
    ///
    /// - Parameters:
    ///   - startDate: start date of required data
    ///   - endDate: end date of required data
    ///   - successBlock: will return steps, distance, floor count, pace, cadence and time
    ///   - errorBlock: will return error
    func getStepsDataFor(startDate: Date , endDate : Date = Date(), successBlock : @escaping  ((_ steps: Int, _ distance: Double, _ averagePace : Double, _ pace : Double, _ floorsAscended : Int , _ floorsDscended : Int, _ cadence : Double, _ timeElapsed : Int ) -> Void), errorBlock : @escaping ((_ error : Error) -> Void)) {
        
        pedometer.queryPedometerData(from: startDate, to: endDate) { (pedometerData, error) in
            if error != nil {
                errorBlock(error!)
            } else if let pedData = pedometerData {
                self.setPedometerData(pedData: pedData)
                successBlock(self.numberOfSteps, self.distance, self.averagePace, self.pace, self.floorsAscended, self.floorsDscended, self.cadence, endDate.secondsInBetweenDate(startDate))
            }
        }
    }
    
   
    private func startTrackingSteps() {
        
        pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
            if let pedData = pedometerData{
                self.setPedometerData(pedData: pedData)
                if self.stepsCountingHandler != nil
                {
                    self.stepsCountingHandler?(self.numberOfSteps, self.distance, self.averagePace, self.pace, self.floorsAscended, self.floorsDscended, self.cadence , Date().secondsInBetweenDate(self.startDate))
                }
            } else {
                self.numberOfSteps = nil
            }
        })
    }
    
    private func setPedometerData(pedData: CMPedometerData)
    {
        self.numberOfSteps = Int(truncating: pedData.numberOfSteps)
        if let distancee = pedData.distance{
            self.distance = Double(truncating: distancee)
        }
        if let averageActivePace = pedData.averageActivePace {
            self.averagePace = Double(truncating: averageActivePace)
        }
        if let currentPace = pedData.currentPace {
            self.pace = Double(truncating: currentPace)
        }
        if let floor = pedData.floorsAscended
        {
            self.floorsAscended = Int(truncating: floor)
        }
        if let floor = pedData.floorsDescended
        {
            self.floorsDscended = Int(truncating: floor)
        }
        if let cadence = pedData.currentCadence
        {
            self.cadence = Double(truncating: cadence)
        }
    }

}
//Mark - stop tracking
extension ActivityHelper{
    fileprivate func stopPedometer()
    {
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
    }
}

extension Date {
    func secondsInBetweenDate(_ date: Date?) -> Int {
        if date == nil
        {
            return 0
        }
        var diff = self.timeIntervalSinceNow - date!.timeIntervalSinceNow
        diff = fabs(diff)
        return Int(diff)
    }
}

