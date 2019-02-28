//
//  TeamHandler.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 2/24/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class TeamHandler {
    
    var runnnerHandlers: [String:RunnerHandler] = [:]
    var stopwatchHandler: MainStopwatchHandler = MainStopwatchHandler()
    
    public func newRunnerHandler(team: String){
    
        let newRunnerHandler: RunnerHandler = RunnerHandler(team: team)
        runnnerHandlers[team] = newRunnerHandler
        
    }
    
    
    
    
    public func printHandlers(){
        print("Runner Handlers: ")
        print(runnnerHandlers)
        
        
    }
    
}


