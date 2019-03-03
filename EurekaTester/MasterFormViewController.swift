//
//  MasterFormViewController.swift
//  EurekaTester
//
//  Created by Ian Fitzgerald on 10/24/18.
//  Copyright © 2018 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class MasterFormViewController: FormViewController, AlertsViewControllerDelegate{
    
    
    
    
    var masterView: MasterHomeViewController = MasterHomeViewController()
    var teamHandler: TeamHandler = TeamHandler()
   
    //var runnerHandler: RunnerHandler = RunnerHandler()
    var count: Int = 0
    let startColor = UIColor(hexString: "#7DFF8F")
    let pauseColor = UIColor(hexString: "#FDFF66")
    var teamName = "team1"
    var buttonList: [String: [UIButton]]  = [:]
    var segmentedTags: [String: String] = [:]
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLayoutSubviews()
        tableView.isEditing = false
        animateScroll = true
        masterView.alerts.delegate = self
        
        //Observers for
        NotificationCenter.default.addObserver(self, selector: #selector(self.newTeam), name: NSNotification.Name(rawValue: "newTeamSender"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.editForm), name: NSNotification.Name(rawValue: "editSender"), object: nil)
        
        
        var buttons = createButtons()
        buttons[2].setTitleColor(.black, for: .normal)
        buttons[3].setTitleColor(.black, for: .normal)
    }
    
    
    @objc func startAction(sender: UIButton!) {
        
        let team = sender.formCell()?.baseRow.section!.tag
        
        if(sender.backgroundColor == .green){
            sender.backgroundColor = .red
            sender.setTitleColor(.white, for: .normal)
            sender.setTitle("STOP", for: .normal)
            sender.formCell()?.backgroundColor = startColor
            teamHandler.runnnerHandlers[team!]?.startTimer(runnerForm: sender)
           // runnerHandler.startTimer(runnerForm: sender)
            UIButton.animate(withDuration: 0.1,
                             animations: {
                                sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
            },
                             completion: { finish in
                                UIButton.animate(withDuration: 0.2, animations: {
                                    sender.transform = CGAffineTransform.identity
                                })
            })
            
        }
        else{
            sender.backgroundColor = .green
            sender.formCell()?.backgroundColor = pauseColor
            sender.setTitleColor(.black, for: .normal)
            sender.setTitle("GO", for: .normal)
            teamHandler.runnnerHandlers[team!]?.stopTimer(runnerForm: sender)
           // runnerHandler.stopTimer(runnerForm: sender)
            
            UIButton.animate(withDuration: 0.1,
                             animations: {
                                sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
            },
                             completion: { finish in
                                UIButton.animate(withDuration: 0.2, animations: {
                                    sender.transform = CGAffineTransform.identity
                                })
            })
        }

    }
    
    
    @objc func splitAction(sender: UIButton!) {
        let team = sender.formCell()?.baseRow.section!.tag!
        let textView = sender.formCell()?.subviews[4] as! UITextView
        teamHandler.runnnerHandlers[team!]?.addSplit(runnerForm: sender, textView: textView)
        
       
    }
    
    
//    @objc func resetAction(sender: UIButton!){
//        print("button tapped")
//        self.reset(resetAll: true)
//    }
    
    @objc func dataAction(sender: UIButton!) {
        let team = sender.formCell()?.baseRow.section!.tag!
        //let runner = teamHandler.runnnerHandlers[team!]?.currentRunner
        let splits = teamHandler.runnnerHandlers[team!]?.runners.getSplits(key: team!)
        //let runner = runnerHandler.currentRunner
        //let splits = runnerHandler.runners.getSplits(key: "team1")
        var masterString = ""
        
       
        for i in splits!{
            masterString.append(i)
        }
        let messageText = NSMutableAttributedString(
            string: masterString,
            attributes: [
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
        )
        
        
        let alert = UIAlertController(title: "Alert", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        alert.setValue(messageText, forKey: "attributedMessage")
        self.viewDidAppear(true)
        self.present(alert, animated: true, completion: nil)
        
        masterString = ""
        
    }
    
    func startAllTeam(team: String){
        
        if(buttonList[team] == nil){
        teamHandler.stopwatchHandler.startTimer(team: team)
        }
        else{
        teamHandler.stopwatchHandler.startTimer(team: team)
        teamHandler.runnnerHandlers[team]?.startAll(runners: buttonList[team]!)
    }
    }
    
    func stopAllTeam(team: String){
        if(buttonList[team] == nil){
        teamHandler.stopwatchHandler.stopTimer(team: team)
        }
        else{
        teamHandler.stopwatchHandler.stopTimer(team: team)
        teamHandler.runnnerHandlers[team]?.stopAll(runners: buttonList[team]!)
        }
    }
    
    func resetAllTeam(team: String){
        
        if(buttonList[team] != nil){
            teamHandler.runnnerHandlers[team]?.resetAll(runners: buttonList[team]!)
        }
    }
    


    private func addSection(teamName: String) -> Section{
        let tag1 = teamName + "Switch"
        let tag2 = teamName.replacingOccurrences(of: " ", with: "") + "seg"
        teamHandler.newRunnerHandler(team: teamName)
        var buttons = createButtons()
        buttons[2].setTitleColor(.black, for: .normal)
        buttons[3].setTitleColor(.black, for: .normal)

        segmentedTags[teamName] = "$\(tag2) == 'Team Options'"
        let section = SegmentedRow<String>(tag2){
            $0.options = ["Runner Data", "Team Options"]
            $0.title = teamName.capitalized
            }
            
            
            <<< ActionSheetRow<String>() {
                $0.title = "Relay type"
                $0.options = ["4 x 100", "4 x 200", "4 x 400"]
                $0.hidden = Condition(stringLiteral: "$\(tag2) != 'Team Options'")
                
        }
        
    
            <<< SwitchRow(tag1){ row in
                row.title = "Relay"
                row.hidden = Condition(stringLiteral: "$\(tag2) == 'Team Options'")
               

                }.onChange{[weak self] row in
                    if(row.value == true){
                        row.title = "Relay started!"
                        row.updateCell()
                    }
                    else{
                        row.title = "Relay"
                        row.updateCell()
                    }
            }

            <<< ButtonRow(){ row in
                row.tag = teamName
                row.hidden = Condition(stringLiteral: "$\(tag2) == 'Team Options'")
                row.title = "Start Team " + teamName.capitalized
                row.baseCell.addSubview(buttons[2])
                row.baseCell.addSubview(buttons[3])
                self.newTimer(team: teamName, sender: row.baseCell)
                
                let resetSwipeAction = SwipeAction(style: .normal, title: "Reset"){ (action, row, completionHandler) in
                    self.teamHandler.stopwatchHandler.mainTimerList[teamName]?.reset(resetAll: true, team: teamName)
                    self.resetAllTeam(team: teamName)
                    completionHandler?(true)
                }
                row.leadingSwipe.actions.append(resetSwipeAction)
                }.onCellSelection{[weak self] cell, row  in
                    row.tag = teamName
                    
                    //self?.teamHandler.stopwatchHandlers[teamName]?.currentTimer = self!.buttonTimers[teamName]!
                    //self!.currentTimer.mainStopwatch = row
                    
                    //self?.mainStopwatch = row
               
                    if(cell.backgroundColor == self?.startColor){
                    //if(self!.teamHandler.stopwatchHandler.getStopwatch(team: teamName).time.status == true){
                    //if(self!.teamHandler.stopwatchHandler.currentTimer.time.status == true){
                        
                        self?.stopAllTeam(team: teamName)

                        cell.textLabel?.textColor = UIColor.black
                        cell.backgroundColor = self!.pauseColor
                        buttons[2].backgroundColor = self!.pauseColor
                        buttons[3].backgroundColor = self!.pauseColor
                        //self?.stopAllTeam(team: teamName)
                    }
                    else{

                        self?.startAllTeam(team: teamName)

                        cell.textLabel?.textColor = UIColor.black
                        cell.backgroundColor = self!.startColor
                        buttons[2].backgroundColor = self!.startColor
                        buttons[3].backgroundColor = self!.startColor
                         //self?.startAllTeam(team: teamName)
                    }
                }.cellUpdate({ cell, row in
                    row.tag = teamName
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
                    cell.textLabel?.textColor = .black

                })

        return section
        
    }
    
    private func createMultivaluedSection(teamName: String) -> Section{
        
      let section = MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                           header: "",
                           footer: ""){
                            //$0.hidden = "$segmented != 'Runners'"
                            $0.tag = teamName
                            $0.showInsertIconInAddButton = false
                            
                            $0.addButtonProvider = { section in
                                
                                return ButtonRow(){ row in
                                    row.title = "Add New Runner"
                                    
                                }
                            }
                            
                            // Telling the section where to insert the new row
                            $0.multivaluedRowToInsertAt = { index in
                                
                                return LabelRow() { row in
                                    row.title = " "
                                    }.cellSetup{ cell, row in
                                        var buttons = self.createButtons()
                                        let textView = self.createTextView()
                                        //Adding buttons to runner cell
                                        cell.addSubview(buttons[0])
                                        cell.addSubview(buttons[1])
                                        cell.addSubview(buttons[3])
                                        cell.addSubview(textView)
                                        
                                        //Handling button list additions
                                        if(self.buttonList[teamName] == nil){
                                        self.buttonList[teamName] = [buttons[0]]
                                        }
                                        else{
                                            self.buttonList[teamName]?.append(buttons[0])
                                        }
                                        
                                        //Animating button appearence
                                        self.present(self.masterView.alerts.showNewRunnerDialog(cell: row.baseCell as! Cell<String>), animated: true, completion: nil)
                                        
                                    //Adjusting cell size
                                    }.cellUpdate({ cell, row in
                                        cell.height = {80}
                                        
                                        
                                    })
                                
                            }
        }
        
        
        return section
    }
    
    
    

    /// A function to create buttons that will be used throughout the form
    ///
    /// - Returns: An array of UIButtons
    func createButtons() -> [UIButton]{

        let title = UIButton(frame: CGRect(x: 5, y: 5, width: 100, height: 20))
        let start = UIButton(frame: CGRect(x: 250, y: 10, width: 80, height: 25))
        let split = UIButton(frame: CGRect(x: 250, y: 45, width: 80, height: 25))
        //let reset = UIButton(frame: CGRect(x:0 , y: 0, width: 100, height: 48))
        let splitData = UIButton(frame: CGRect(x:275 , y: 0, width: 100, height: 48))

        //Setting up positions for animations
        title.center.x -= view.bounds.width
        start.center.x += view.bounds.width
        split.center.x += view.bounds.width

        start.backgroundColor = .green
        start.setTitle("GO", for: .normal)
        start.setTitleColor(.black, for: .normal)
        start.titleLabel?.font = .systemFont(ofSize: 12)
        start.addTarget(self, action: #selector(self.startAction), for: .touchUpInside)

        split.backgroundColor = .blue
        split.setTitle("Split", for: .normal)
        split.titleLabel?.font = .systemFont(ofSize: 12)
        split.addTarget(self, action: #selector(self.splitAction), for: .touchUpInside)

//        reset.setTitle("RESET", for: .normal)
//        reset.addTarget(self, action: #selector(self.resetAction), for: .touchUpInside)
//        reset.layer.borderWidth = 1.0
//        reset.layer.borderColor = UIColor.black.cgColor

        splitData.setTitle("Data", for: .normal)
        splitData.layer.borderWidth = 1.0
        splitData.layer.borderColor = UIColor.black.cgColor
        splitData.addTarget(self, action: #selector(self.dataAction), for: .touchUpInside)

        title.backgroundColor = .orange
        title.setTitle("", for: .normal)
        title.layer.masksToBounds = false
        title.layer.shadowColor = UIColor.black.cgColor
        title.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        title.layer.shadowOpacity = 0.5
        title.setTitleColor(.black, for: .normal)

        return [start, split, splitData, title]

    }
    
    func createTextView() -> UITextView{
        
        
        let textView = UITextView(frame: CGRect(x: 140, y: 0, width: 80, height: 80))
        textView.backgroundColor = .white
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 14)
    
        return textView
    }
    
   
   


    ///DELEGATE AND NOTIFICATION METHODS
    
    @objc func editForm(_ n:Notification){
        if let check = n.userInfo?.first!.key{
            let button = check as! UIBarButtonItem
            tableView.setEditing(!tableView.isEditing, animated: true)
            button.title = tableView.isEditing ? "Done" : "Edit"
        }
    }
    
    @objc func newTeam(_ n:Notification) {
        
        let team = n.userInfo!.first!.key.base
        //form +++ addSegmentedRow(teamName: team as! String)
        form +++ addSection(teamName: team as! String)
        form +++ createMultivaluedSection(teamName: team as! String)
        
    }
    
    func editPressed(sender: UIBarButtonItem){
        //masterView.editButton.title = tableView.isEditing ? "Done" : "Edit"
        
        tableView.setEditing(!self.tableView.isEditing, animated: true)
        sender.title = self.tableView.isEditing ? "Done" : "Edit"
        
    }
    
//    func deleteFromButtonList(cell: Cell<String>) {
//        for b in buttonList{
//            if(b.formCell() == cell){
//                buttonList.removeLast()
//            }
//        }
//    }
    
    func animateStart(cell: Cell<String>) {
//        masterView.editButton.target = self
//        masterView.sendSignal(button: masterView.editButton)
//
      
        UIView.animate(withDuration: 0.8, delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.3,
                       options: [], animations: {
                        cell.subviews[2].center.x -= self.view.bounds.width
                        
        }, completion: nil)
    }
    
    func animateSplit(cell: Cell<String>) {
        
        UIView.animate(withDuration: 0.8, delay: 0.1,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.3,
                       options: [], animations: {
                        cell.subviews[1].center.x -= self.view.bounds.width
                        
        }, completion: nil)
    }
    
    func newRunner(firstName: String, lastName: String, membership: String, cell: BaseCell) {
        teamHandler.runnnerHandlers[membership]?.runners.createRunner(fName: firstName, lName: lastName, membership: membership, cell: cell)
       // runnerHandler.runners.createRunner(fName: firstName, lName: lastName, membership: membership, cell: cell)
    }
    
    private func newTimer(team: String, sender: BaseCell){
       
        teamHandler.stopwatchHandler.createMember(team: team, sender: sender)
    }
    
}
    

    

