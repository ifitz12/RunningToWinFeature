//
//  AlertsViewController.swift
//  EurekaTester
//
//  Created by Ian Fitzgerald on 11/11/18.
//  Copyright © 2018 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class AlertsViewController: UIViewController{

    var teamName: String = ""
    var firstName: String = ""
    var lastName: String = ""
    //var runnerList: Dictionary<String, [RunnerModel.Runner]>? = nil
    var runners: RunnerModel = RunnerModel() //RunnerModel(list: runnerList)
    var currentRunner = RunnerModel.Runner()
    //var timeModel = TimerModel()
    var timeString = ""
    var timerList: Dictionary<String, TimerModel> = [:]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    
    
    
    func showNewRunnerDialog(cell: Cell<String>) -> UIAlertController{
        let alertController = UIAlertController(title: "New Runner", message: "", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            self.firstName = (alertController.textFields?[0].text)!.trimmingCharacters(in: [" ", "."])
            self.lastName = (alertController.textFields?[1].text)!.trimmingCharacters(in: [" ", "."])
            
            if(self.firstName == "" || self.lastName == ""){
                let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.viewDidAppear(true)
                self.present(alert, animated: true, completion: nil)
                
            }
                
            else{
                cell.baseRow.title = self.firstName.capitalized + " " + String(self.lastName.first!).capitalized + "."
                self.runners.createRunner(fName: self.firstName, lName: self.lastName, membership: (cell.baseRow.section?.tag!)!, cell: cell)

                cell.update()
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            cell.baseRow.title = "Runner"
            cell.update()
        }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "First Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Last Name"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        return alertController
    }

    func showNewTeamDialog() -> UIAlertController{
        let alertController = UIAlertController(title: "New Team", message: "", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            self.teamName = (alertController.textFields?[0].text)!
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Team Name"
        }
        
        let importAction = UIAlertAction(title: "Import", style: .default) { (_) in }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.addAction(importAction)
        
        print(cancelAction)
        return alertController
    }

    private func setRunner(runner: UIButton) -> RunnerModel.Runner{
        let team = runner.formCell()?.baseRow.section?.tag!.lowercased()
        var name = runner.formCell()?.textLabel?.text?.split(separator: " ")
        let fname = name![0].lowercased()
        let lname = name![1].lowercased()
        self.teamName = team!
        let d = lname.split(separator: ".")
        return runners.getRunner(teamName: team!, runnerFirstName: fname, runnerLastInitial: String(d[0]))
    
    }
    
   private func runnerInList(runner: RunnerModel.Runner) -> Bool{
        var name = runner.lastName
        for i in timerList{
            if(i.key == name){
                return true
            }
       }
        
        return false
    }

    private func runnerHasChanged(runnerForm: UIButton) -> Bool {
        let dummy = setRunner(runner: runnerForm)
        
        if(currentRunner.lastName != dummy.lastName){
            return true
        }
        else{
            return false
    }
    }
    
    
    func startTimer(runnerForm: UIButton){
        
        currentRunner = setRunner(runner: runnerForm)
        
        if(!runnerInList(runner: currentRunner)){
            let newRun: TimerModel = TimerModel()
            newRun.createEntry(runner: currentRunner)
            timerList[currentRunner.lastName] = newRun
            print(timerList)
        }
        print(timerList)
        timerList[currentRunner.lastName]?.start()
        
        print("start clicked")
        print(currentRunner.firstName)
        }
    
    func stopTimer(runnerForm: UIButton){
        
        if(runnerHasChanged(runnerForm: runnerForm)){
            
            currentRunner = setRunner(runner: runnerForm)
        }
        
        timerList[currentRunner.lastName]?.stop()
        runners.updateTimeElement(runner: timerList[currentRunner.lastName]!.getEntry())
        print("stop clicked")
        print(currentRunner.firstName)
    }
    
    
    func addSplit(runnerForm: UIButton){
        if(runnerHasChanged(runnerForm: runnerForm)){
            currentRunner = setRunner(runner: runnerForm)
        }
        //currentRunner.time.splits.append(timeString)
        let time = timerList[currentRunner.lastName]?.timeString
        timerList[currentRunner.lastName]?.currentRunner.time.splits.append(time!)
        print("split added for: ")
        print(timerList[currentRunner.lastName]?.currentRunner)
    }
    
    func runnerData(runnerForm: UIButton) -> String{
        if(runnerHasChanged(runnerForm: runnerForm)){
            
            currentRunner = setRunner(runner: runnerForm)
        }
        var splits = ""
        var i: Int = 1;
        for str in (timerList[currentRunner.lastName]?.currentRunner.time.splits)!{//currentRunner.time.splits{
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
    
    

}
