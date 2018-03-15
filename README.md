# CMPedometerDemo
Let's count steps using CMPedometer


# Usage
 #### Live steps
  
 ```swift
 activityHelper.stepsCountingHandler = { steps,
            distance,
            averagePace,
            pace,
            floorsAscended,
            floorsDscended,
            cadence,
            timeElapsed in
        }
 ```
  Then start observing using: 
  
  ```swift
    activityHelper.startMonitoring()
  ```
  
  To Stop observing Steps:
  
  ```swift
    activityHelper.stopMonitoring()
  ```
  
   #### Historical steps
   
   ```swift
   let startDate = Date() // Your desire start date
        let endDate = Date() // Your desire end date
        activityHelper.getStepsDataFor(startDate: startDate,
                                       endDate: endDate,
                                       successBlock: {(steps,
                                        distance,
                                        averagePace,
                                        pace,
                                        floorsAscended,
                                        floorsDscended,
                                        cadence,
                                        timeElapsed )  in
                                        
        }, errorBlock: { (error) in
            
        })
   ```
