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

    
}
