//
//  RunnerHandler.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 2/6/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka

struct RunnerHandler {
    
    var teamName: String = ""
    var currentRunner:RunnerModel.Runner //RunnerModel.Runner()
    var runners: RunnerModel
    
    init(team: String){
        self.teamName = team
        self.runners = RunnerModel(team: team)
        self.currentRunner = RunnerModel.Runner()
    }
    
    
    var timerList: Dictionary<String, TimerModel> = [:]
    //var currentRunner = RunnerModel.Runner()
    //var runners: RunnerModel = RunnerModel()
    let startColor = UIColor(hexString: "#7DFF8F")
    let pauseColor = UIColor(hexString: "#FDFF66")
    var timeString = ""
    //let alerts: AlertsViewController = AlertsViewController()
  
   
/// Local function used to set the current runner in focus
private func setRunner(runner: UIButton) -> RunnerModel.Runner{
    //runners.printRunnerList()
    let team = runner.formCell()?.baseRow.section?.tag!.lowercased()
    //var name = runner.formCell()?.baseRow.title?.split(separator: " ")
    var name = (runner.formCell()!.subviews[3] as? UIButton)?.currentTitle?.split(separator: " ")

    let fname = name![0].lowercased()
    let lname = name![1].lowercased()
    //self.teamName = team!
    let d = lname.split(separator: ".")
    
    return runners.getRunner(teamName: team!, runnerFirstName: fname, runnerLastInitial: String(d[0]))

}

/// Local function used for checking if a runner has an initialized timer associated with them
private func runnerInList(runner: RunnerModel.Runner) -> Bool{
    let name = runner.lastName
    for i in timerList{
        if(i.key == name){
            return true
        }
    }
    return false
}

/// Local function that serves as a workaround for a bug that was
/// causing timers to not match up with their respective runners
private func runnerHasChanged(runnerForm: UIButton) -> Bool {
    let dummy = setRunner(runner: runnerForm)

    if(currentRunner.lastName != dummy.lastName){
        return true
    }
    else{
        return false
    }
}


/// Start timer for individual runner
    mutating func startTimer(runnerForm: UIButton, relay: Bool){
    currentRunner = setRunner(runner: runnerForm)
        print("timer started")
    if(!runnerInList(runner: currentRunner)){
        let newRun: TimerModel = TimerModel()
        newRun.createEntry(runner: currentRunner, runnerButton: runnerForm)
        timerList[currentRunner.lastName] = newRun
        
    }
    runnerForm.formCell()?.backgroundColor = startColor
        timerList[currentRunner.lastName]?.start(relay: relay)

    
}

/// Stop timer for individual runner
    mutating func stopTimer(runnerForm: UIButton){

    if(runnerHasChanged(runnerForm: runnerForm)){
        currentRunner = setRunner(runner: runnerForm)
    }
    runnerForm.formCell()?.backgroundColor = pauseColor
    timerList[currentRunner.lastName]?.stop()
    runners.updateTimeElement(runner: timerList[currentRunner.lastName]!.getEntry())
    
}

/// Add split for individual runner
    mutating func addSplit(runnerForm: UIButton, textView: UITextView){
    if(runnerHasChanged(runnerForm: runnerForm)){
        currentRunner = setRunner(runner: runnerForm)
    }
    //currentRunner.time.splits.append(timeString)
    let time = timerList[currentRunner.lastName]?.timeString
        DispatchQueue.main.async {
        
        textView.text.append(time! + "\n")
        let range = NSMakeRange(textView.text.characters.count - 1, 0)
        textView.scrollRangeToVisible(range)
        }
    timerList[currentRunner.lastName]?.currentRunner.time.splits.append(time!)
    runners.updateTimeElement(runner: timerList[currentRunner.lastName]!.getEntry())

}


///***NOT CURRENTLY USED***
/// Was used for individual split data buttons attached to each runner cell
    mutating func runnerData(runnerForm: UIButton) -> String{
    if(runnerHasChanged(runnerForm: runnerForm)){

        currentRunner = setRunner(runner: runnerForm)
    }
    var splits = ""
    var i: Int = 1;
    for str in (timerList[currentRunner.lastName]?.currentRunner.time.splits)!{
        if(str != ""){
            splits += String(i) + ". " + str + "\n"
            i+=1
        }
    }
    if(i == 1){
        return "Runner has no splits"
    }
    return splits
}

/// Starts all runners within a team
    mutating func startAll(runners: [UIButton]){
        print(self.runners.masterRunnerList)
    for runner in runners{
        let textField = runner.formCell()?.subviews[4] as! UITextView
        if(runner.backgroundColor == UIColor.red ){
            currentRunner = setRunner(runner: runner)
            
            timerList[currentRunner.lastName]?.reset()
            timerList[currentRunner.lastName]?.start(relay: false)
            
        }else{

            currentRunner = setRunner(runner: runner)
            if(!runnerInList(runner: currentRunner)){
                let newRun: TimerModel = TimerModel()
                newRun.createEntry(runner: currentRunner, runnerButton: runner)
                timerList[currentRunner.lastName] = newRun
            }
            runner.backgroundColor = .red
            runner.setTitleColor(.white, for: .normal)
            runner.setTitle("STOP", for: .normal)
            runner.formCell()?.backgroundColor = startColor
            textField.backgroundColor = startColor
            timerList[currentRunner.lastName]?.start(relay: false)
        }
    }

}

/// Stops all runners within a team
    mutating func stopAll(runners: [UIButton]){
        
    for runner in runners{
        let textField = runner.formCell()?.subviews[4] as! UITextView
        currentRunner = setRunner(runner: runner)
        if(!runnerInList(runner: currentRunner)){
            let newRun: TimerModel = TimerModel()
            newRun.createEntry(runner: currentRunner, runnerButton: runner)
            timerList[currentRunner.lastName] = newRun
        }
        runner.backgroundColor = .green
        runner.formCell()?.backgroundColor = pauseColor
        runner.setTitleColor(.black, for: .normal)
        runner.setTitle("GO", for: .normal)
        textField.backgroundColor = pauseColor
        timerList[currentRunner.lastName]?.stop()
        self.runners.updateTimeElement(runner: timerList[currentRunner.lastName]!.getEntry())

    }


}

/// Resets all runners within a team
    mutating func resetAll(runners: [UIButton]){
    if(timerList.isEmpty){
        print("can't reset timers that haven't been started")
    }
    else{
        stopAll(runners: runners)
        for runner in runners{
            currentRunner = setRunner(runner: runner)
            let textField = runner.formCell()?.subviews[4] as! UITextView
            timerList[currentRunner.lastName]?.currentRunner.time.timer?.invalidate()
            weak var t: Timer?
            let resetSplits: [String] = []
            timerList[currentRunner.lastName]?.currentRunner.time.timer = t
            timerList[currentRunner.lastName]?.currentRunner.time.time = 0
            timerList[currentRunner.lastName]?.currentRunner.time.startTime = 0
            timerList[currentRunner.lastName]?.currentRunner.time.elapsed = 0
            timerList[currentRunner.lastName]?.currentRunner.time.splits = resetSplits
            textField.text = ""
            textField.backgroundColor = .white
            runner.formCell()?.baseRow.title = "00:00.00"
            runner.formCell()?.baseRow.baseCell.backgroundColor = .white
            runner.formCell()?.update()
        }
    }
}
    
    

    

}
