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
    var mainButonList: Dictionary<String, MainStopwatchTimerModel.Stopwatch>
    var currentTimer: MainStopwatchTimerModel.Stopwatch
    
    
    init(){
        self.mainTimerList = [:]
        self.currentTimer = MainStopwatchTimerModel.Stopwatch()
        self.mainButonList = [:]
    }
    
    
    mutating func createMember(team: String, sender: BaseCell){
        var new: MainStopwatchTimerModel.Stopwatch = MainStopwatchTimerModel.Stopwatch()
        new.membership = team
        new.time.mainStopwatch = sender
        
        mainButonList[team] = new
        
    }
    
    mutating func getStopwatch(team: String) -> MainStopwatchTimerModel.Stopwatch{
        
        return mainButonList[team]!
    }
    
    mutating func updateTimeElement(timer: MainStopwatchTimerModel.Stopwatch){
        
        if(mainButonList[timer.membership] != nil){
            mainButonList[timer.membership] = timer
            
        }
        
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
        let dummy = getStopwatch(team: team)
        
        if(currentTimer.membership != dummy.membership){
            return true
        }
        else{
            return false
        }
    }
    
    
    mutating func startTimer(team: String){
        
        currentTimer = getStopwatch(team: team)
        
        if(!timerInList(team: currentTimer.membership)){
            let newTime: MainStopwatch = MainStopwatch()
            newTime.setCurrent(stopwatch: currentTimer)
            mainTimerList[currentTimer.membership] = newTime
        }
        
        mainTimerList[currentTimer.membership]?.start()
    }
    
    /// Stop timer for individual runner
    mutating func stopTimer(team: String){
        
        if(timerHasChanged(team: team)){
            currentTimer = getStopwatch(team: team)
            
        }
        
        mainTimerList[currentTimer.membership]?.stop()
        updateTimeElement(timer: (mainTimerList[currentTimer.membership]?.getEntry())!)
        
    }
}
