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


protocol AlertsViewControllerDelegate: class {
    func deleteFromButtonList(cell: Cell<String>)
    func animateStart(cell: Cell<String>)
    func animateSplit(cell: Cell<String>)
}


class AlertsViewController: UIViewController{

    weak var delegate: AlertsViewControllerDelegate?
    var teamName: String = ""
    var firstName: String = ""
    var lastName: String = ""
    let startColor = UIColor(hexString: "#7DFF8F")
    let pauseColor = UIColor(hexString: "#FDFF66")
    //var runnerList: Dictionary<String, [RunnerModel.Runner]>? = nil
    var runners: RunnerModel = RunnerModel() //RunnerModel(list: runnerList)
    var currentRunner = RunnerModel.Runner()
    //var timeModel = TimerModel()
    var timeString = ""
    var timerList: Dictionary<String, TimerModel> = [:]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    
    
    /// Presenting the new runner dialog box
    func showNewRunnerDialog(cell: Cell<String>) -> UIAlertController{
        let alertController = UIAlertController(title: "New Runner", message: "", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            var name = (alertController.textFields?[0].text)!.split(separator: " ")
            
            self.firstName = name[0].trimmingCharacters(in: ["."])
            self.lastName = name[1].trimmingCharacters(in: ["."])

            if(self.firstName == "" || self.lastName == ""){
                let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.viewDidAppear(true)
                self.present(alert, animated: true, completion: nil)
            }
                
            else{
                
                (cell.subviews[3] as? UIButton)?.setTitle(self.firstName.capitalized + " " + String(self.lastName.first!).capitalized + ".", for: .normal)
                
                UIView.animate(withDuration: 0.8, delay: 0,
                                           usingSpringWithDamping: 0.6,
                                           initialSpringVelocity: 0.3,
                                           options: [], animations: {
                                            cell.subviews[3].center.x += self.view.bounds.width
                                            
                }, completion: nil)
                cell.baseRow.baseValue = "00:00.00"
               
                self.delegate?.animateStart(cell: cell)
                self.delegate?.animateSplit(cell: cell)
                self.runners.createRunner(fName: self.firstName, lName: self.lastName, membership: (cell.baseRow.section?.tag!)!, cell: cell)
                cell.update()
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            cell.baseRow.section?.remove(at: cell.baseRow.indexPath!.row)
            self.delegate?.deleteFromButtonList(cell: cell)
            cell.update()
        }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            confirmAction.isEnabled = false
            textField.placeholder = "Full Name"
            textField.addTarget(alertController, action: #selector(alertController.textDidChangeInLoginAlert), for: .editingChanged)
        }
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Last Name"
//            textField.addTarget(alertController, action: #selector(alertController.textDidChangeInLoginAlert), for: .editingChanged)
//        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        //confirmAction.isEnabled = false
        
        //finally presenting the dialog box
        return alertController
    }

    
    /// Presenting the new team dialog box
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
    
    func newTeamName() -> String {
        return self.teamName
    }

    
    /// Local function used to set the current runner in focus
    private func setRunner(runner: UIButton) -> RunnerModel.Runner{
        runners.printRunnerList()
        let team = runner.formCell()?.baseRow.section?.tag!.lowercased()
        //var name = runner.formCell()?.baseRow.title?.split(separator: " ")
        var name = (runner.formCell()!.subviews[3] as? UIButton)?.currentTitle?.split(separator: " ")
       
        let fname = name![0].lowercased()
        let lname = name![1].lowercased()
        self.teamName = team!
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
    func startTimer(runnerForm: UIButton){
        currentRunner = setRunner(runner: runnerForm)
        
        if(!runnerInList(runner: currentRunner)){
            let newRun: TimerModel = TimerModel()
            newRun.createEntry(runner: currentRunner, runnerButton: runnerForm)
            timerList[currentRunner.lastName] = newRun
            print(timerList)
        }
        print(timerList)
        timerList[currentRunner.lastName]?.start()
        
        print("start clicked")
        print(currentRunner.firstName)
        }
    
    /// Stop timer for individual runner
    func stopTimer(runnerForm: UIButton){
        
        if(runnerHasChanged(runnerForm: runnerForm)){
            currentRunner = setRunner(runner: runnerForm)
        }
        
        timerList[currentRunner.lastName]?.stop()
        runners.updateTimeElement(runner: timerList[currentRunner.lastName]!.getEntry())
        print("stop clicked")
        print(currentRunner.firstName)
    }
    
    /// Add split for individual runner
    func addSplit(runnerForm: UIButton){
        if(runnerHasChanged(runnerForm: runnerForm)){
            currentRunner = setRunner(runner: runnerForm)
        }
        //currentRunner.time.splits.append(timeString)
        let time = timerList[currentRunner.lastName]?.timeString
        
        timerList[currentRunner.lastName]?.currentRunner.time.splits.append(time!)
        runners.updateTimeElement(runner: timerList[currentRunner.lastName]!.getEntry())
        
    }
    
    
    ///***NOT CURRENTLY USED***
    /// Was used for individual split data buttons attached to each runner cell
    func runnerData(runnerForm: UIButton) -> String{
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
    func startAll(runners: [UIButton]){
        for runner in runners{
            
            if(runner.backgroundColor == UIColor.red ){
                currentRunner = setRunner(runner: runner)
                timerList[currentRunner.lastName]?.reset()
                timerList[currentRunner.lastName]?.start()
                print("RUNNER RESET")
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
            timerList[currentRunner.lastName]?.start()
            }
        }
        
    }
    
    /// Stops all runners within a team
    func stopAll(runners: [UIButton]){
        for runner in runners{
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
            timerList[currentRunner.lastName]?.stop()
            self.runners.updateTimeElement(runner: timerList[currentRunner.lastName]!.getEntry())
            
        }
        
        
    }
    
    /// Resets all runners within a team
    func resetAll(runners: [UIButton]){
        if(timerList.isEmpty){
            print("can't reset timers that haven't been started")
        }
        else{
            stopAll(runners: runners)
            for runner in runners{
                currentRunner = setRunner(runner: runner)
                
                timerList[currentRunner.lastName]?.currentRunner.time.timer?.invalidate()
                weak var t: Timer?
                let resetSplits: [String] = []
                timerList[currentRunner.lastName]?.currentRunner.time.timer = t
                timerList[currentRunner.lastName]?.currentRunner.time.time = 0
                timerList[currentRunner.lastName]?.currentRunner.time.startTime = 0
                timerList[currentRunner.lastName]?.currentRunner.time.elapsed = 0
                timerList[currentRunner.lastName]?.currentRunner.time.splits = resetSplits
                
                runner.formCell()?.baseRow.baseValue = "00:00.00"
                runner.formCell()?.baseRow.baseCell.backgroundColor = .white
                runner.formCell()?.update()
            }
        }
    }
    
}


// Input validation
extension UIAlertController {

    func isFullName(name: String) -> Bool{
      
        let fname = name.split(separator: " ")
        if (fname.count != 0 && fname.count > 1 && fname.count < 3){
        return true
        }
        else{
            return false
        }
        
    }

    @objc func textDidChangeInLoginAlert() {
       let name =  (textFields?[0].text)

            let action = actions.first
    action?.isEnabled = isFullName(name: name!)

    }
    
}
    
    
    

