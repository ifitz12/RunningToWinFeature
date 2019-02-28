//
//  MainStopwatch.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 2/25/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit


class MainStopwatch{
    
    let pauseColor = UIColor(hexString: "#FDFF66")
    let startColor = UIColor(hexString: "#7DFF8F")
    
    var currentTimer: MainStopwatchTimerModel.Stopwatch = MainStopwatchTimerModel.Stopwatch()
    
    
    func setCurrent(stopwatch: MainStopwatchTimerModel.Stopwatch){
        self.currentTimer = stopwatch
        
    }
    
    func getEntry() -> MainStopwatchTimerModel.Stopwatch{
        return self.currentTimer
    }
    
    
    func start() {
        
        currentTimer.time.startTime = Date().timeIntervalSinceReferenceDate - currentTimer.time.elapsed
        currentTimer.time.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        currentTimer.time.status = true
        
        currentTimer.time.mainStopwatch.backgroundColor = startColor
        currentTimer.time.mainStopwatch.update()
        
    }
    
    func stop() {
        
        currentTimer.time.elapsed = Date().timeIntervalSinceReferenceDate - currentTimer.time.startTime
        currentTimer.time.timer?.invalidate()
        
        
        currentTimer.time.status = false
      
    }
    
    func reset(resetAll: Bool, team: String){
        if(resetAll){
            //teamHandler.runnnerHandlers[team]?.resetAll(runners: buttonList[team]!)
            //runnerHandler.resetAll(runners: buttonList[team]!)
        }
        //Reseting timer attributes
        currentTimer.time.timer?.invalidate()
        weak var t: Timer?
        currentTimer.time.timer = t
        currentTimer.time.time = 0
        currentTimer.time.startTime = 0
        currentTimer.time.elapsed = 0
        currentTimer.time.status = false
        
        currentTimer.time.mainStopwatch.baseRow.title = "00:00.00"
        currentTimer.time.mainStopwatch.backgroundColor = .white
        currentTimer.time.mainStopwatch.update()
        
        
    }
    
    @objc func update() {
        
        print(currentTimer.membership)
        print(currentTimer.time.time)
        print(currentTimer.time.timer)
        // Calculate total time since timer started in seconds
        
        currentTimer.time.time = Date().timeIntervalSinceReferenceDate - currentTimer.time.startTime
        // time = Date().timeIntervalSinceReferenceDate - startTime
        
        // Calculate minutes
        let minutes = UInt64(currentTimer.time.time / 60.0)
        currentTimer.time.time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt64(currentTimer.time.time)
        currentTimer.time.time -= TimeInterval(seconds)
        
        // Calculate milliseconds
        let milliseconds = UInt64(currentTimer.time.time * 100)
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMilliseconds = String(format: "%02d", milliseconds)
        
        let currentTime = strMinutes + ":" + strSeconds + "." + strMilliseconds
       
        currentTimer.time.mainStopwatch.baseRow.title = currentTime
        currentTimer.time.mainStopwatch.update()
        //mainStopwatch!.title = currentTime
        
       
    }
    
    
    
    
}
