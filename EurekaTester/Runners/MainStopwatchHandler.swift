//
//  MainStopwatchHandler.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 2/25/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka

struct MainStopwatchHandler{
    
    var mainTimerList: Dictionary<String, MainStopwatch>
    var currentTimer: MainStopwatchTimerModel.Stopwatch
    var timers: MainStopwatchTimerModel
    
    init(){
        self.mainTimerList = [:]
        self.currentTimer = MainStopwatchTimerModel.Stopwatch()
        self.timers = MainStopwatchTimerModel()
    }
  
    
    private mutating func setTimer(team: String) -> MainStopwatchTimerModel.Stopwatch{
  
    
    return timers.getTimer(team: team)
        
    }
    
   
    
    
    private  func timerInList(team: String) -> Bool{
        let timer = mainTimerList[team]
        
        if(timer == nil){
            return false
        }
        else{
            
            return true
        }
    }
    
    
    private mutating func timerHasChanged(team: String) -> Bool {
        let dummy = setTimer(team: team)
        
        if(currentTimer.membership != dummy.membership){
            return true
        }
        else{
            return false
        }
    }
    
    
    mutating func startTimer(team: String){
        currentTimer = setTimer(team: team)
        
        
        if(!timerInList(team: currentTimer.membership)){
            let newTime: MainStopwatch = MainStopwatch()
            newTime.setCurrent(stopwatch: currentTimer)
            mainTimerList[team] = newTime
            
        }
        mainTimerList[currentTimer.membership]?.start(team: currentTimer.membership)
        
        
        
    }
    
    /// Stop timer for individual runner
    mutating func stopTimer(team: String){
        
        if(timerHasChanged(team: team)){
            currentTimer = setTimer(team: team)
        }
        mainTimerList[currentTimer.membership]?.stop(team: currentTimer.membership)
        
        timers.updateTimeElement(timer: mainTimerList[currentTimer.membership]!.getEntry())
        
    }
    
    
    
}
