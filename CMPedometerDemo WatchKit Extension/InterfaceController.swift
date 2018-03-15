//
//  InterfaceController.swift
//  CMPedometerDemoWatchApp Extension
//
//  Created by Tejas Ardeshna on 14/03/18.
//  Copyright © 2018 Simform Solutions PVT. LTD. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    // MARK: - IBOutlets
    @IBOutlet var lblTime: WKInterfaceLabel!
    @IBOutlet var lblSteps: WKInterfaceLabel!
    @IBOutlet var lblCadence: WKInterfaceLabel!
    @IBOutlet var lblPace: WKInterfaceLabel!
    @IBOutlet var lblAvgPace: WKInterfaceLabel!
    @IBOutlet var lblDistance: WKInterfaceLabel!
    @IBOutlet var lblFloorsUp: WKInterfaceLabel!
    @IBOutlet var lblFloorsDown: WKInterfaceLabel!
    @IBOutlet var btnStartUpdating: WKInterfaceButton!
    var startDate : Date?
    
    var isObserverRunning: Bool = false
    // MARK: - Action Methods
    @IBAction func btnStartClicked() {
        if isObserverRunning
        {
            activityHelper.stopMonitoring()
            btnStartUpdating.setTitle("Start Updating Steps")
        }
        else
        {
            activityHelper.startMonitoring()
            btnStartUpdating.setTitle("Stop Updating Steps")
        }
        isObserverRunning = !isObserverRunning
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        //Let's check availbale permissions first
        activityHelper.isStepCountingAvailable ? lblSteps.setTextColor(UIColor.green) : lblSteps.setTextColor(UIColor.red)
        activityHelper.isPaceAvailable ? lblPace.setTextColor(UIColor.green) : lblPace.setTextColor(UIColor.red)
         activityHelper.isPaceAvailable ? lblAvgPace.setTextColor(UIColor.green) : lblAvgPace.setTextColor(UIColor.red)
        activityHelper.isCadenceAvailable ? lblCadence.setTextColor(UIColor.green) : lblCadence.setTextColor(UIColor.red)
        activityHelper.isDistanceAvailable ? lblDistance.setTextColor(UIColor.green) : lblDistance.setTextColor(UIColor.red)
        activityHelper.isFloorCountingAvailable ? lblFloorsUp.setTextColor(UIColor.green) : lblFloorsUp.setTextColor(UIColor.red)
        activityHelper.isFloorCountingAvailable ? lblFloorsDown.setTextColor(UIColor.green) : lblFloorsDown.setTextColor(UIColor.red)
        
        //fetch historical pedometer data
        /* pass relevant start date and end date for historical data
        let startDate = Date().addingTimeInterval(-900)
        let endDate = Date()
        activityHelper.getStepsDataFor(startDate: startDate,
                                       endDate: endDate,
                                       successBlock: {(steps, distance, averagePace, pace, floorsAscended, floorsDscended, cadence,timeElapsed )  in
            self.lblSteps.setText("Steps : \(steps)")
            self.lblDistance.setText("Distance : \(self.getDistanceString(distance: distance))")
            self.lblAvgPace.setText("Avg Pace : \(self.calculateAvgPace(distance: distance, timeElapsed: timeElapsed))")
            self.lblPace.setText("Pace : \(self.getPaceString(pace: pace))")
            self.lblCadence.setText("Cadence : \(self.getPaceString(pace: cadence))")
            self.lblFloorsUp.setText("Floors Up : \(floorsAscended)")
            self.lblFloorsDown.setText("Floors Down : \(floorsDscended)")
            self.lblTime.setText("Time : \(self.secondsToHoursMinutesSeconds(timeElapsed))")
        }, errorBlock: { (error) in
            
        })
        */
        
        //Add activity observer here to bind data
        activityHelper.stepsCountingHandler = { steps, distance, averagePace, pace, floorsAscended, floorsDscended, cadence, timeElapsed in
            self.lblSteps.setText("Steps : \(steps)")
            self.lblDistance.setText("Distance : \(self.getDistanceString(distance: distance))")
            self.lblAvgPace.setText("Avg Pace : \(self.calculateAvgPace(distance: distance, timeElapsed: timeElapsed))")
            self.lblPace.setText("Pace : \(self.getPaceString(pace: pace))")
            self.lblCadence.setText("Cadence : \(self.getPaceString(pace: cadence))")
            self.lblFloorsUp.setText("Floors Up : \(5)")
            self.lblFloorsDown.setText("Floors Down : \(3)")
            self.lblTime.setText("Time : \(self.secondsToHoursMinutesSeconds(timeElapsed))")
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
extension InterfaceController
{
    // convert seconds to hh:mm:ss as a string
    func secondsToHoursMinutesSeconds (_ seconds : Int) -> String
    {
        let hours = seconds / 3600
        let min = (seconds % 3600) / 60
        let sec = (seconds % 3600) % 60
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, min, sec)
        } else {
            return String(format: "%02i:%02i", min, sec)
        }
    }
    func calculateAvgPace(distance : Double, timeElapsed : Int )-> String {
          return getPaceString(pace: distance / Double(timeElapsed))
    }
    func getPaceString(pace : Double) -> String
    {
        return String(format: "%02.2f m/s",pace)
    }
    func getDistanceString(distance : Double) -> String
    {
        return String(format:"%02.02f mtr",distance)
    }
}
