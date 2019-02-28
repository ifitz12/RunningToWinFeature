//
//  MainStopwatchTimerModel.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 2/24/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka

struct MainStopwatchTimerModel{
    
    struct buttonTimeElements{
        weak var timer: Timer?
        var startTime: Double = 0
        var time: Double = 0
        var elapsed: Double = 0
        var status: Bool = false
        var mainStopwatch: BaseCell = BaseCell()
    }
    
    struct Stopwatch{
        var membership: String = ""
        var time: buttonTimeElements = buttonTimeElements()
        
    }
    
    //var masterStopwatchList: Dictionary<String, MainStopwatchTimerModel.Stopwatch> = [:]
    
    
//    mutating func createTimer(team: String, sender: BaseCell){
//        
//        masterStopwatchList[team] = Stopwatch(membership: team, time: buttonTimeElements(timer: Timer(), startTime: 0, time: 0, elapsed: 0, status: false, mainStopwatch: sender))
//        
//    }
    
//    mutating func getTimer(team: String) -> MainStopwatchTimerModel.Stopwatch{
//        
//        return masterStopwatchList[team]!
//    }
//    
//    mutating func updateTimeElement(timer: MainStopwatchTimerModel.Stopwatch){
//        
//        if(masterStopwatchList[timer.membership] != nil){
//            
//            masterStopwatchList[timer.membership] = timer
//        }
//        
//    }
    
}
