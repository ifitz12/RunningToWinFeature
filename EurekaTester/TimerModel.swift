//
//  TimerModel.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 11/16/18.
//  Copyright © 2018 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit



/// For tracking all of the individual timers for each runner
class TimerModel{

    //Setting the current runner to be used throughout the iteration
    var currentRunner: RunnerModel.Runner = RunnerModel.Runner()
    var button: UIButton = UIButton()
    let pauseColor = UIColor(hexString: "#FDFF66")
    let startColor = UIColor(hexString: "#7DFF8F")
    var timeString = ""
    
    func createEntry(runner: RunnerModel.Runner, runnerButton: UIButton){
        self.currentRunner = runner
        self.button = runnerButton
    }
    
    func getEntry() -> RunnerModel.Runner{
        
        return self.currentRunner
    }
    

    
    /// Start funtion for an individual timer, called by StartAll() for each runner
    func start(){
        button.backgroundColor = .red
        button.formCell()?.backgroundColor = startColor
        button.setTitleColor(.black, for: .normal)
        button.setTitle("STOP", for: .normal)
        
        currentRunner.time.startTime = Date().timeIntervalSinceReferenceDate - currentRunner.time.elapsed
        currentRunner.time.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        
        // Set Start/Stop button to true
        currentRunner.time.status = true
       
        currentRunner.cell.formCell()?.baseRow.baseCell.backgroundColor = startColor
        currentRunner.cell.formCell()?.update()
    }
    
    func stop()  {
        
        
        currentRunner.time.elapsed = Date().timeIntervalSinceReferenceDate - currentRunner.time.startTime
        currentRunner.time.timer?.invalidate()
        
        // Set Start/Stop button to false
        currentRunner.time.status = false
    }
    
    func reset(){
        
        button.backgroundColor = .green
        button.formCell()?.backgroundColor = pauseColor
        button.setTitleColor(.black, for: .normal)
        button.setTitle("GO", for: .normal)
        
        currentRunner.time.timer?.invalidate()
        weak var t: Timer?
        currentRunner.time.timer = t
        currentRunner.time.time = 0
        currentRunner.time.startTime = 0
        currentRunner.time.elapsed = 0
        let splits: [String] = []
        currentRunner.time.splits = splits
        
        currentRunner.cell.formCell()?.baseRow.title  = "00:00.00"
       // currentRunner.cell.formCell()?.baseRow.baseValue = "00:00.00"
        currentRunner.cell.formCell()?.baseRow.baseCell.backgroundColor = .white
        currentRunner.cell.formCell()?.update()
        
    }
    
    @objc func updateCounter(){
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
        timeString = total
        currentRunner.cell.baseRow.title = total
        //currentRunner.cell.baseRow.baseValue = total
        currentRunner.cell.formCell()?.update()
        
        
        
    }
   
}
