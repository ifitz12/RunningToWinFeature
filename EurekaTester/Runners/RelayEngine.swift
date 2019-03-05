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
    
    
    init(){
        
    NotificationCenter.default.addObserver(self, selector: #selector(self.startRelay), name: NSNotification.Name(rawValue: "startRelay"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.stopRelay), name: NSNotification.Name(rawValue: "stopRelay"), object: nil)
        
    }
    
    func createButton() -> UIButton{
        
        let splitButton = UIButton(frame: CGRect(x: 200, y: 0, width: 80, height: 25))
        splitButton.backgroundColor = .red
        splitButton.addTarget(self, action: #selector(self.split), for: .touchUpInside)
        
        return splitButton
    }
    
    @objc func startRelay(_ n:Notification) {
        let button = createButton()
       
        let handler = n.object as! TeamHandler
        let type = n.userInfo!["type"] as! String
        //let segmentedRow: SegmentedRow = n.userInfo!["segment"] as! SegmentedRow<String>
        let switchRow = n.userInfo!["switch"] as! SwitchRow
        let teamName = n.userInfo!["name"] as! String
        let buttonList = n.userInfo!["list"] as! [UIButton]
        currentSwitchRow = switchRow
        currentSwitchRow.baseCell.addSubview(button)
        //segmentedRow.hidden = true
       // print(segmentedRow.isHidden)
        
        self.currentHandler = handler
        self.buttons = buttonList
        self.relayType = type
        self.teamName = teamName
        
        currentHandler.stopwatchHandler.mainTimerList[teamName]?.reset(resetAll: true, team: teamName)
        currentHandler.runnnerHandlers[teamName]!.resetAll(runners: buttonList)
        currentHandler.stopwatchHandler.startTimer(team: teamName)
        currentHandler.runnnerHandlers[teamName]!.startTimer(runnerForm: buttonList[0], relay: true)
        setButtonsStatus(buttons: buttons)
        setRelay(type: type)
        
    }
    
    @objc func stopRelay(_ n:Notification) {
        
        let handler = n.object as! TeamHandler
        let type = n.userInfo!["type"]
        let switchRow = n.userInfo!["switch"] as! SwitchRow
        let teamName = n.userInfo!["name"] as! String
        let buttonList = n.userInfo!["list"] as! [UIButton]
        
       // handler.runnnerHandlers[teamName]?.startTimer(runnerForm: , relay: <#T##Bool#>)
        
        
        print("stopped relay")
    }
    
    
    @objc func split(){
        //Adding split and stopping for finished runner
        let textView = currentHandler.runnnerHandlers[teamName]!.currentRunner.cell.subviews[4] as! UITextView
        currentHandler.runnnerHandlers[teamName]!.addSplit(runnerForm: buttons[count], textView: textView)
        currentHandler.runnnerHandlers[teamName]!.stopTimer(runnerForm: buttons[count])
        
        

        if(count != 3){
            count += 1
            currentHandler.runnnerHandlers[teamName]!.startTimer(runnerForm: buttons[count], relay: true)

        }
        else if(typeCount != 0){
            count = 0
            typeCount -= 1
            currentHandler.runnnerHandlers[teamName]!.startTimer(runnerForm: buttons[count], relay: true)
        }
        else{
            currentHandler.stopwatchHandler.stopTimer(team: teamName)
            setButtonsStatus(buttons: buttons)
            currentSwitchRow.baseCell.subviews[1].removeFromSuperview()
            currentSwitchRow.value = false
            
            count = 0
            typeCount = 0
        }

        print("split")
        
    }
    
    func setRelay(type: String){
        
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
    
    func relayTypeError() -> UIAlertController{
        
        let alert = UIAlertController(title: "Error", message: "Relay type must be set in 'Team Options'", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        return alert
    }
    
   
    func relaySizeError() -> UIAlertController{
        
        let alert = UIAlertController(title: "Error", message: "This relay type requires at least 4 runners", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        return alert
        
     
    }
  
    
    func setButtonsStatus(buttons: [UIButton]){
    
        for button in buttons{
            (button.isEnabled) ? (button.isEnabled = false) : (button.isEnabled = true)
            if(!button.isEnabled){
                button.backgroundColor = .gray
            }
            else{
                button.backgroundColor = .green
        }
        
    }
    }
    
    
    
    
    
    
}
