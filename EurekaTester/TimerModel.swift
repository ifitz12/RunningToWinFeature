//
//  TimerModel.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 11/16/18.
//  Copyright © 2018 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit



class TimerModel{

    var currentRunner: RunnerModel.Runner = RunnerModel.Runner()
    
    func createEntry(runner: RunnerModel.Runner){
        self.currentRunner = runner
    }
    
    func getEntry() -> RunnerModel.Runner{
        
        return self.currentRunner
    }
    
    func start(){

        currentRunner.time.startTime = Date().timeIntervalSinceReferenceDate - currentRunner.time.elapsed
        currentRunner.time.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        
        // Set Start/Stop button to true
        currentRunner.time.status = true
        //print("started: " )
        //print(currentRunner.time)
    }
    
    func stop()  {
        
        
        currentRunner.time.elapsed = Date().timeIntervalSinceReferenceDate - currentRunner.time.startTime
        currentRunner.time.timer?.invalidate()
        
        // Set Start/Stop button to false
        currentRunner.time.status = false
        //print("stopped: ")
        //print(currentRunner.time)
        
        //runners.updateTimeElement(runner: currentRunner)
        
    }
    
    @objc func updateCounter(){   //runner: [String: RunnerModel.Runner], runnerCell: UIButton){
        //var hold = currentRunner
        
        //var run = runner.
        // Calculate total time since timer started in seconds
        currentRunner.time.time = Date().timeIntervalSinceReferenceDate - currentRunner.time.startTime
        
        // Calculate minutes
        let minutes = UInt64(currentRunner.time.time / 60.0)
        currentRunner.time.time -= (TimeInterval(minutes) * 60)
        
        
        // Calculate seconds
        let seconds = UInt64(currentRunner.time.time)
        currentRunner.time.time -= TimeInterval(seconds)
        
        // Calculate milliseconds
        let milliseconds = UInt64(currentRunner.time.time * 100)
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMilliseconds = String(format: "%02d", milliseconds)
        
        let total = strMinutes + ":" + strSeconds + "." + strMilliseconds
        ///timeString = total
        currentRunner.cell.baseRow.baseValue = total
        currentRunner.cell.formCell()?.update()
        
        
        
    }
    
    
    
    
    
}
