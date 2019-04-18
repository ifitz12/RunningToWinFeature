//
//  RelayEngine.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 3/3/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class RelayEngine{
    
    var currentHandler: TeamHandler = TeamHandler()
    var relayType: String = ""
    var teamName: String = ""
    var buttons: [UIButton] = []
    var count: Int = 0
    var typeCount: Int = 0
    var currentSwitchRow: SwitchRow = SwitchRow()
    var handoffButton: UIButton = UIButton()
    let startColor = UIColor(hexString: "#7DFF8F")
    let pauseColor = UIColor(hexString: "#FDFF66")
   
    
    
    init(){
        
    NotificationCenter.default.addObserver(self, selector: #selector(self.startRelay), name: NSNotification.Name(rawValue: "startRelay"), object: nil)
    }
    
   private func createButton() -> UIButton{
        
        let splitButton = UIButton(frame: CGRect(x: 290, y: 5, width: 80, height: 35))
        splitButton.backgroundColor = .cyan
        splitButton.titleLabel?.font = .systemFont(ofSize: 15)
    
        splitButton.setTitle("Handoff", for: .normal)
        splitButton.setTitleColor(.black, for: .normal)
        splitButton.addTarget(self, action: #selector(self.split), for: .touchUpInside)
        
        return splitButton
    }
    
    @objc func startRelay(_ n:Notification) {
        let button = createButton()
        handoffButton = button
       
        handoffButton.layer.cornerRadius = 10
        handoffButton.clipsToBounds = true
        
        let handler = n.object as! TeamHandler
        let type = n.userInfo!["type"] as! String
        //let segmentedRow: SegmentedRow = n.userInfo!["segment"] as! SegmentedRow<String>
        let switchRow = n.userInfo!["switch"] as! SwitchRow
        let teamName = n.userInfo!["name"] as! String
        let buttonList = n.userInfo!["list"] as! [UIButton]
        
        currentSwitchRow = switchRow
        currentSwitchRow.baseCell.addSubview(handoffButton)
        
        self.currentHandler = handler
        self.buttons = buttonList
        self.relayType = type
        self.teamName = teamName
        
        currentHandler.stopwatchHandler.mainTimerList[teamName]?.reset(resetAll: true, team: teamName)
        currentHandler.runnnerHandlers[teamName]!.resetAll(runners: buttonList)
        currentHandler.stopwatchHandler.startTimer(team: teamName)
        
        currentHandler.runnnerHandlers[teamName]!.startTimer(runnerForm: buttonList[0], relay: true)
        //let test = currentSwitchRow.baseCell.subviews[5] as! UIButton
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeAddRunner"), object: teamName)
        //let split = currentHandler.runnnerHandlers[teamName]!.currentRunner.cell.subviews[2] as! UIButton
//        split.frame = CGRect(x: 250, y: 5, width: 80, height: 50)
//        split.titleLabel?.font = .systemFont(ofSize: 20)
//        split.layer.cornerRadius = 20
//        split.clipsToBounds = true
//        button.formCell()?.update()
        setButtonsStatus(buttons: buttons, end: false)
        setRelay()
        
        
    }
    

    @objc func split(){
        //Adding split and stopping for finished runner
        let textView = currentHandler.runnnerHandlers[teamName]!.currentRunner.cell.subviews[4] as! UITextView
        //let split = currentHandler.runnnerHandlers[teamName]!.currentRunner.cell.subviews[2] as! UIButton
        currentHandler.runnnerHandlers[teamName]!.addSplit(runnerForm: buttons[count], textView: textView)
        currentHandler.runnnerHandlers[teamName]!.stopTimer(runnerForm: buttons[count])
        
        if(count != 3){
            count += 1
            currentHandler.runnnerHandlers[teamName]!.startTimer(runnerForm: buttons[count], relay: true)
            setButtonsStatus(buttons: buttons, end: false)
            
        }
        else if(typeCount != 0){
            count = 0
            typeCount -= 1
            currentHandler.runnnerHandlers[teamName]!.startTimer(runnerForm: buttons[count], relay: true)
            setButtonsStatus(buttons: buttons, end: false)
        }
        else{
            currentHandler.stopwatchHandler.stopTimer(team: teamName)
            setButtonsStatus(buttons: buttons, end: true)
            
            //handoffButton.removeFromSuperview()
            stopRelay()
            currentSwitchRow.value = false
            count = 0
            typeCount = 0
            presentSaveOption()
        }
        
     
        
    }
    
    func stopRelay(){
        
        print("HERE!!!")
        //currentHandler.runnnerHandlers[teamName]!.resetAll(runners: buttonList)
        currentHandler.stopwatchHandler.stopTimer(team: teamName)
        setButtonsStatus(buttons: buttons, end: true)
        animateButton(button: handoffButton, remove: true, duration: 0.5)
//        handoffButton.removeFromSuperview()
        
        currentSwitchRow.value = false
        count = 0
        typeCount = 0
        
        
        
    }
    
    func animateButton(button: UIButton, remove: Bool, duration: Double){
        
        UIView.animate(withDuration: duration, animations: { () -> Void in
            if(remove){
            button.alpha = 0;
            }
            else{
            button.alpha = 1;
            }
            
        })
      
    }
    
   
    
    
    
    func presentSaveOption() -> UIAlertController{
        let alertController = UIAlertController(title: "Save relay?", message: "", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateData"), object: nil)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
       
        return alertController
        
    }
    
    func setRelay(){
       
        switch relayType{
            
        case "4 x 100":
            typeCount  = 0
        case "4 x 200":
            typeCount  = 1
        case "4 x 400":
            typeCount  = 3
        default:
            print("Relay not available")
            
        }
    }
 
   
    func relaySizeError() -> UIAlertController{
        
        let alert = UIAlertController(title: "Error", message: "This relay type requires exactly 4 runners. Try adding or removing runners to continue", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        return alert
    }
    
    
    private func setButtonsStatus(buttons: [UIButton], end: Bool){
        
        let mainStopwatch = currentHandler.stopwatchHandler.getStopwatch(team: teamName).time.mainStopwatch

        
        for button in buttons{
            
            let split = button.formCell()?.subviews[2] as! UIButton
            let start = button.formCell()?.subviews[1] as! UIButton
            let buttonColor = button.formCell()?.backgroundColor
            
            if(!end){
                animateButton(button: start, remove: true, duration: 0.5)
                //start.isHidden = true
                mainStopwatch.isUserInteractionEnabled = false
                if (buttonColor != startColor){
                    animateButton(button: split, remove: true, duration: 0.5)
                    //split.isHidden = true
                }
                    
                else {
                    
                    animateButton(button: split, remove: false, duration: 0.2)
                    //split.isHidden = false
                    split.frame = CGRect(x: 250, y: 15, width: 90, height: 50)
                    split.layer.cornerRadius = 10
                    split.clipsToBounds = true
                    split.titleLabel?.font = .systemFont(ofSize: 17)
                    button.formCell()?.update()
                }
            }
            else{
                
                split.frame = CGRect(x: 300, y: 10, width: 60, height: 60)
                split.titleLabel?.font = .systemFont(ofSize: 15)
                animateButton(button: split, remove: false, duration: 0.5)
                animateButton(button: start, remove: false, duration: 0.5)
                //split.isHidden = false
               // start.isHidden = false
                mainStopwatch.isUserInteractionEnabled = true
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "saveOption"), object: presentSaveOption(), userInfo: nil)
                
            }
            
            
        }
    }
    
}
