//
//  RunnerModel.swift
//  EurekaTester
//
//  Created by Ian Fitzgerald on 11/11/18.
//  Copyright © 2018 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka


struct RunnerModel {

    var teamName: String = ""
    
    init(team: String){
        self.teamName = team
    }
    
    
    struct timeElements{
        weak var timer: Timer?
        var startTime: Double = 0
        var time: Double = 0
        var elapsed: Double = 0
        var status: Bool = false
        var splits: [String] = []
    }
    
    struct Runner {
        
        var firstName: String = ""
        var lastName: String = ""
        var membership: String = ""
        var cell: BaseCell = BaseCell()
        var time: timeElements = timeElements()
        
    }
    
    
    /// Initializing the master runner list. Each new runner gets an entry with the following initializers
    var masterRunnerList: Dictionary<String, [RunnerModel.Runner]>? = ["initializer": [Runner(firstName: "", lastName: "", membership: "initializer", cell: BaseCell(), time: timeElements(timer: Timer(), startTime: 0, time: 0, elapsed: 0, status: false, splits: []))]]
    
    
  mutating func createRunner(fName: String, lName: String, membership: String, cell: BaseCell){
        let lower = membership.lowercased()
    
        if(teamInDictionary(team: membership)){
            
            masterRunnerList![lower]?.append(Runner(firstName: fName, lastName: lName, membership: lower, cell: cell, time: timeElements(timer: Timer(), startTime: 0, time: 0, elapsed: 0, status: false, splits: [])))
        }
        else{
            
            masterRunnerList![lower] = [Runner(firstName: fName, lastName: lName, membership: lower, cell: cell, time: timeElements(timer: Timer(), startTime: 0, time: 0, elapsed: 0, status: false, splits: []))]
        }
    }
    
    
    ///Debug function for looking at all current runners
    func printRunnerList() {
        print("ALL RUNNERS ============================================= ")
        for i in 0...masterRunnerList!.count-2 {
            for run in masterRunnerList!{
                if(run.key != "initializer"){
                    let runner = run.value[i]
                    print(runner.membership + ": " + runner.firstName + " " + runner.lastName +  " - " )
                    print("Time: \(runner.time.time) Elapsed: \(runner.time.elapsed) \n")
                    print("Splits: \(runner.time.splits) ")
                }
            }
        }
        print("=============================================================")
        
    }
    
    func getFullName(button: UIButton) -> String{
        let team = button.formCell()?.baseRow.section?.tag!
        var name = (button.formCell()!.subviews[4] as? UIButton)?.currentTitle?.split(separator: " ")
        let fname = name![0].lowercased()
        let lname = name![1].lowercased()
        let run = getRunner(teamName: team!, runnerFirstName: fname, runnerLastInitial: lname)
        
        return run.firstName.capitalized + " " + run.lastName.capitalized
    
    }
    
    
    func teamInDictionary(team: String) -> Bool{
        let new = team.lowercased()
        
        for i in masterRunnerList!{
            
            if(i.key == new){
                return true
            }
        }
        return false
    }
    
    
    func getSplits(key: String) -> [String]{
        var allSplits: [String] = []
        var str = ""
        var workingStr = ""
        var counter = 0;
        var num = 1
        
        
        if(masterRunnerList![key] != nil){
        for r in masterRunnerList![key]!{
            workingStr = r.firstName.capitalized + " " +  r.lastName.capitalized + "\n" + "\n"
            //str = ""
            print("werk string = " + workingStr)
            for time in r.time.splits{
                
                workingStr.append(String(num) + ". " + time + "\n")
                num+=1
            }
            num = 1
            allSplits.append(workingStr)
            
        }
        }
        
       //// print(allSpltis)
        return allSplits
        
    }
    
    
    func getRunner(teamName: String, runnerFirstName: String, runnerLastInitial: String) -> RunnerModel.Runner{
        
        
        let team = teamName.lowercased()
        var runnersByTeam = masterRunnerList![team]
        let size = runnersByTeam?.count
        let first = runnerFirstName.lowercased()
        let last = String(runnerLastInitial.lowercased().first!)
        
        
        for i in 0...size!-1{

            if(runnersByTeam![i].firstName == first && String(runnersByTeam![i].lastName.first!) == last){
                return runnersByTeam![i]
            }
        }
        print("ERROR IN GETTING RUNNER")
        return (masterRunnerList?.first?.value[0])!
        
        
    }
    
    mutating func updateTimeElement(runner: RunnerModel.Runner){
        let team = runner.membership.lowercased()
        let fName = runner.firstName.lowercased()
        let lName = runner.lastName
        
        var count = 0
        for run in masterRunnerList![team]!{
            
            if (run.firstName == fName && run.lastName == lName) {
                
                masterRunnerList![team]![count] = runner
               print()
                
        }
            count+=1
    
    }
        
}
}
