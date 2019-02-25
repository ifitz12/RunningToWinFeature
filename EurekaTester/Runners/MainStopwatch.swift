//
//  MainStopwatch.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 2/25/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class MainStopwatch{
    
   
    
    var currentTimer: MainStopwatchTimerModel.Stopwatch = MainStopwatchTimerModel.Stopwatch()
    
    
    func setCurrent(stopwatch: MainStopwatchTimerModel.Stopwatch){
        
        self.currentTimer = stopwatch
        
    }
    
    func getEntry() -> MainStopwatchTimerModel.Stopwatch{
        
        return self.currentTimer
    }
    
    
    func start(team: String) {
        
        //teamHandler.runnnerHandlers[team]?.startAll(runners: buttonList[team.lowercased()]!)
        
        self.currentTimer.time.startTime = Date().timeIntervalSinceReferenceDate - self.currentTimer.time.elapsed
        // self.startTime = Date().timeIntervalSinceReferenceDate - self.elapsed
        DispatchQueue.main.async{
            self.currentTimer.time.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            //self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }
        // Set Start/Stop button to true
        self.currentTimer.time.status = 1
        //self.status = 1
        
        
    }
    
    func stop(team: String) {
        
       // teamHandler.runnnerHandlers[team]?.stopAll(runners: buttonList[team]!)
        
        self.currentTimer.time.elapsed = Date().timeIntervalSinceReferenceDate - self.currentTimer.time.startTime
        //self.elapsed = Date().timeIntervalSinceReferenceDate - self.startTime
        self.currentTimer.time.timer?.invalidate()
        //self.timer?.invalidate()
        
        // Set Start/Stop button to false
        self.currentTimer.time.status = 0
        //self.status = 0
        
        
    }
    
    func reset(resetAll: Bool, team: String){
        if(resetAll){
            //teamHandler.runnnerHandlers[team]?.resetAll(runners: buttonList[team]!)
            //runnerHandler.resetAll(runners: buttonList[team]!)
        }
        //Reseting timer attributes
        self.currentTimer.time.timer?.invalidate()
        weak var t: Timer?
        self.currentTimer.time.timer = t
        self.currentTimer.time.time = 0
        self.currentTimer.time.startTime = 0
        self.currentTimer.time.elapsed = 0
        self.currentTimer.time.status = 0
        
        self.currentTimer.time.mainStopwatch.baseRow.title = "00:00.00"
        self.currentTimer.time.mainStopwatch.backgroundColor = .white
        self.currentTimer.time.mainStopwatch.baseRow.updateCell()
        
    }
    
    @objc func update() {
        
        
        // Calculate total time since timer started in seconds
        
        self.currentTimer.time.time = Date().timeIntervalSinceReferenceDate - self.currentTimer.time.startTime
        // time = Date().timeIntervalSinceReferenceDate - startTime
        
        // Calculate minutes
        let minutes = UInt64(self.currentTimer.time.time / 60.0)
        self.currentTimer.time.time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt64(self.currentTimer.time.time)
        self.currentTimer.time.time -= TimeInterval(seconds)
        
        // Calculate milliseconds
        let milliseconds = UInt64(self.currentTimer.time.time * 100)
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMilliseconds = String(format: "%02d", milliseconds)
        
        let currentTime = strMinutes + ":" + strSeconds + "." + strMilliseconds
        //self.buttonTimers[(currentTimer.mainStopwatch?.baseCell.formCell()?.baseRow.section!.tag)!] = currentTimer
        //self.buttonTimers[(currentTimer.mainStopwatch?.baseCell.formCell()?.baseRow.section!.tag)!]?.mainStopwatch?.title = currentTime
        self.currentTimer.time.mainStopwatch.baseRow.title = currentTime
        
        //mainStopwatch!.title = currentTime
        
        DispatchQueue.main.async{
            //self.buttonTimers[(self.currentTimer.mainStopwatch?.baseCell.formCell()?.baseRow.section!.tag)!]?.mainStopwatch?.updateCell()
            self.currentTimer.time.mainStopwatch.update()
            //self.mainStopwatch?.updateCell()
        }
    }
    
    
    
    
}
