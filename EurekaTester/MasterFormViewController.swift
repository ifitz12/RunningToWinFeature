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

//API URL: https://r2wmobile4.running2win.com/api.asmx


class MasterFormViewController: FormViewController, AlertsViewControllerDelegate{ //UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate{
    
    var masterView: MasterHomeViewController = MasterHomeViewController()
    var teamHandler: TeamHandler = TeamHandler()
    var relayEngine: RelayEngine = RelayEngine()
    var teamData: TeamData = TeamData()
    let startColor = UIColor(hexString: "#7DFF8F")
    let pauseColor = UIColor(hexString: "#FDFF66")
    var teams: [String] = []
    var buttonList: [String: [UIButton]]  = [:]
    var segmentedTags: [String: String] = [:]
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //super.viewDidLayoutSubviews()
        tableView.isEditing = false
        animateScroll = true
        masterView.alerts.delegate = self
        
        self.form = Form()
        //Observers for
        NotificationCenter.default.addObserver(self, selector: #selector(self.newTeam), name: NSNotification.Name(rawValue: "newTeamSender"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.editForm), name: NSNotification.Name(rawValue: "editSender"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentSave), name: NSNotification.Name(rawValue: "saveOption"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeAddRunner), name: NSNotification.Name(rawValue: "removeAddRunner"), object: nil)
      
        
        
        
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
            teamHandler.runnnerHandlers[team!]?.startTimer(runnerForm: sender, relay: false)
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
        print("IS BUTTON LIST NIL")
        print(buttonList[team] == nil)
        if(buttonList[team] != nil){
            teamHandler.runnnerHandlers[team]?.resetAll(runners: buttonList[team]!)
        }
    }
    
    
    
    private func addSection(teamName: String) -> Section{
        let tag1 = teamName.replacingOccurrences(of: " ", with: "") + "Switch"
        let tag2 = teamName.replacingOccurrences(of: " ", with: "") + "seg"
        let tag3 = teamName.replacingOccurrences(of: " ", with: "") + "action"
        let tag4 = teamName.replacingOccurrences(of: " ", with: "") + "button"
        teams.append(teamName)
        teamHandler.newRunnerHandler(team: teamName)
        var buttons = createButtons()
        buttons[2].setTitleColor(.black, for: .normal)
        buttons[3].setTitleColor(.black, for: .normal)
        
        segmentedTags[teamName] = "$\(tag2) == 'Team Options'"
        let section = SegmentedRow<String>(tag2){
            $0.options = ["Timer", "Runner Data", "Team Options"]
            $0.title = teamName.capitalized
            $0.value = "Timer"
            
            
            }
            
            
            <<< ActionSheetRow<String>(tag3) {
                $0.title = "Relay type"
                $0.options = ["4 x 100", "4 x 200", "4 x 400"]
                $0.value = "4 x 100"
                $0.hidden = Condition(stringLiteral: "$\(tag2) != 'Team Options'")
                
            }
            
            
            <<< SwitchRow(tag1){ row in
                row.title = "Relay"
                row.hidden = Condition(stringLiteral: "$\(tag2) != 'Timer'")
//                let segmentedRow = self.form.rowBy(tag: tag2)
//                NotificationCenter.default.addObserver(self, selector: #selector(self.updateData), name: NSNotification.Name(rawValue: "updateData"), object: segmentedRow)
//
                
                }.onChange{[weak self] row in
                    
                    guard let runnerCount = self!.buttonList[teamName]?.count else{
                        self?.present(self!.relayEngine.relaySizeError(), animated: true, completion: nil)
                        row.value = false
                        row.updateCell()
                        return
                    }
                    
                    
                    if let relayType = self!.form.rowBy(tag: tag3)?.baseValue{
                        
                        if (runnerCount != 4) {
                            self?.present(self!.relayEngine.relaySizeError(), animated: true, completion: nil)
                            row.value = false
                            row.updateCell()
                        }
                        else if(row.value == true){
                            print("buttonLIST")
                            print(self!.buttonList[teamName])
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startRelay"), object: self!.teamHandler, userInfo: ["name": teamName, "segment": self!.form.rowBy(tag: tag2) as Any, "list": self!.buttonList[teamName]! , "type": relayType as Any, "switch": self!.form.rowBy(tag: tag1) as Any] as [AnyHashable : Any])
                            
                            if let segmentedRow = self!.form.rowBy(tag: tag2){
                                segmentedRow.hidden = true
                                segmentedRow.evaluateHidden()
                            }
                            
                            self!.form.rowBy(tag: tag2)?.updateCell()
                            row.title = "Relay started! " + (relayType as! String)
                            row.updateCell()
                            self?.didReorder(team: teamName)
                            
                        }
                            
                        else{
                            
                            if let segmentedRow = self!.form.rowBy(tag: tag2){
                                segmentedRow.hidden = false
                                segmentedRow.evaluateHidden()
                                self!.form.sectionBy(tag: teamName)?.allRows[4].hidden = false
                                self!.form.sectionBy(tag: teamName)?.allRows[4].evaluateHidden()
                            
                                self?.teamData.createRunnerDataCells(forTeam: teamName, rowTag: tag2, dataSet: self!.teamHandler)
                                
                                //form.a <<< rows[0]
                                NotificationCenter.default.addObserver(self!, selector: #selector(self!.updateData), name: NSNotification.Name(rawValue: "updateData"), object: segmentedRow)
                                //self!.form.insert(self!.teamData.getSection(), at: ((segmentedRow.indexPath?.row)!+2))
                                
                                segmentedRow.updateCell()
                            }
                            
                            row.title = "Relay:"
                            row.updateCell()
                        }
                    }
                    
                    
            }
            
            
            <<< ButtonRow(tag4){ row in
                row.tag = teamName
                row.hidden = Condition(stringLiteral: "$\(tag2) != 'Timer'")
                row.title = "Start Team " + teamName.capitalized
                //row.baseCell.addSubview(buttons[2])
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
                    
                    cell.backgroundColor == self?.startColor ? self?.stopAllTeam(team: teamName) : self?.startAllTeam(team: teamName)
                    
                    cell.textLabel?.textColor = UIColor.black
                    
                }.cellUpdate({ cell, row in
                    row.tag = teamName
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
                    cell.textLabel?.textColor = .black
                    
                })
        
        return section
        
    }
    
    private func createMultivaluedSection(teamName: String) -> Section{
        let switchTag = teamName.replacingOccurrences(of: " ", with: "") + "seg"
        let section = MultivaluedSection(multivaluedOptions: [.Reorder, .Insert],
                                         header: "",
                                         footer: ""){
                                            
                                            //$0.hidden = "$segmented != 'Runners'"
                                            $0.tag = teamName
                                            $0.showInsertIconInAddButton = false
                                            $0.hidden = Condition(stringLiteral: "$\(switchTag) != 'Timer'")
                                            $0.addButtonProvider = { section in
                                                
                                                return ButtonRow(){ row in
                                                    row.title = "Add New Runner"
                                                    
                                                }
                                                
                                            }
                                            
                                            
                                            // Telling the section where to insert the new row
                                            $0.multivaluedRowToInsertAt = { index in
                                                
                                                return LabelRow() { row in
                                                    row.title = " "
                                                   // var buttons = self.createButtons()
                                                    
//                                                    let deleteSwipeAction = SwipeAction(style: .destructive, title: "Delete"){ (action, row, completionHandler) in
//
//                                                        self.removeRunner(membership: teamName, row: row)
//
//                                                        self.removeFromButtonList(button: buttons[0], team: teamName)
//                                                        self.teamHandler.runnnerHandlers[teamName]?.removeFromTimerList(runner: buttons[3])
//                                                        self.removeCell(cell: row.baseCell)
//                                                        self.didReorder(team: teamName)
//
//
//
//                                                        completionHandler!(true)
//
//
//                                                    }
//                                                    row.trailingSwipe.actions = [deleteSwipeAction]
                                                    //var buttons = self.createButtons()
//                                                                                       let deleteSwipeAction = SwipeAction(style: .destructive, title: "Delete"){ (action, row, completionHandler) in
//                                                    self.removeRunner(membership: teamName, row: row)
//                                                                                            var count = 0
//                                                                                            for b in self.buttonList[teamName]!{
//                                                                                                print(self.buttonList)
//                                                                                                if(buttons[0].frame.maxX > 300){
//                                                                                                    self.buttonList[teamName]!.remove(at: count)
//                                                                                                    row.baseCell.removeFromSuperview()
//                                                                                                    print(self.buttonList)
//                                                                                                    break
//
//                                                                                                }
//                                                                                                count += 1
//                                                                                            }
//
//
//                                                    self.removeFromButtonList(button: buttons[0], team: teamName)
//                                                                                       completionHandler?(true)
//                                                                                   }
//                                                                                  row.trailingSwipe.actions = [deleteSwipeAction]
//
                                                    }.cellSetup{ cell, row in
                                                        var buttons = self.createButtons()
                                                        let textView = self.createTextView()
                                                        //Adding buttons to runner cell
                                                        cell.addSubview(buttons[0])
                                                        cell.addSubview(buttons[1])
                                                        cell.addSubview(buttons[3])
                                                        cell.addSubview(textView)
                                                        
                                                        
                                                        let deleteSwipeAction = SwipeAction(style: .destructive, title: "Delete"){ (action, row, completionHandler) in
                                                            
                                                            self.teamHandler.runnnerHandlers[teamName]?.removeFromTimerList(runner: buttons[3])
                                                            
                                                            self.removeRunner(membership: teamName, row: row)
                                                            
                                                            self.removeFromButtonList(button: buttons[0], team: teamName)
                                                
                                                            self.removeCell(cell: row.baseCell)
                                                            self.didReorder(team: teamName)
                                                            
                                                            
                                                            
                                                            completionHandler!(true)
                                                            
                                                            
                                                        }
                                                        row.trailingSwipe.actions = [deleteSwipeAction]
//                                                         let deleteSwipeAction = SwipeAction(style: .destructive, title: "Delete"){ (action, row, completionHandler) in
//                                                            print("YO")
//
//
//                                                            self.removeRunner(membership: teamName, row: row)
//                                                            self.removeFromButtonList(button: buttons[0], team: teamName)
//                                                            self.removeCell(cell: cell)
//
//
//                                                        }
                                                        //row.trailingSwipe.actions = [deleteSwipeAction]
                                                        
                                                        
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
        split.titleLabel?.font = .systemFont(ofSize: 13)
        split.addTarget(self, action: #selector(self.splitAction), for: .touchUpInside)
        
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
    
    func removeCell(cell: BaseCell){
        print("cell removed")
        cell.baseRow.section?.remove(at: cell.baseRow.indexPath!.row)
        cell.update()
    }
    
    
    ///DELEGATE AND NOTIFICATION METHODS
    
    @objc func editForm(_ n:Notification){
        if let check = n.userInfo?.first!.key{
            let button = check as! UIBarButtonItem
            tableView.setEditing(!tableView.isEditing, animated: true)
            button.title = tableView.isEditing ? "Done" : "Edit"
        }
        
        if(!self.tableView.isEditing){
            for team in teams{
                didReorder(team: team)
            }
            
        }
        
    }

    
    
    @objc func updateData( n:Notification){
        
        let segmentedRow = n.object as! SegmentedRow<String>
        self.form.insert(self.teamData.getSection(), at: (segmentedRow.indexPath?.row)!+2)
        
    }
    
    
    @objc func removeAddRunner(n:Notification){
        
        var tag = n.object as! String
        
        self.form.sectionBy(tag: tag)?.allRows[4].hidden = true
        self.form.sectionBy(tag: tag)?.allRows[4].evaluateHidden()
        //f!.allRows[4].hidden = true
        //f?.allRows[4].baseCell.update()
        
        
        
        
    }
    
    @objc func newTeam(_ n:Notification) {
        
        let team = n.userInfo!.first!.key.base
        
        self.form +++ addSection(teamName: team as! String)
        self.form +++ createMultivaluedSection(teamName: team as! String)
        
    }
    
    @objc func presentSave(_ n:Notification) {
        let controller = n.object as! UIAlertController
        self.present(controller, animated: true, completion: nil)
        
    }
    
//    func endRelayConfirmation(row: SwitchRow){
//
//        if(row.value == true){
//
//
//        let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to end this relay?", preferredStyle: .alert)
//        //the confirm action taking the inputs
//        let confirmAction = UIAlertAction(title: "Yes, end", style: .destructive) { (_) in
//            row.value = false
//            row.reload()
//
//            }
//
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        alertController.addAction(confirmAction)
//        alertController.addAction(cancelAction)
//
//        self.present(alertController, animated: true, completion: nil)
//
//        }
//
//    }
    
    
    
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
    
    func removeRunner(membership: String, row: BaseRow){
      
        teamHandler.runnnerHandlers[membership]?.runners.removeRunner(membership: membership, baseRow: row)
        
    }
    
    func removeFromButtonList(button: UIButton, team: String){
        
        var count = 0
        
        for b in self.buttonList[team]!{
            print(b)
            print(button.formCell())
            if(b.formCell() == button.formCell()){
                print("found match!")
                self.buttonList[team]?.remove(at: count)
                break
            }
            
            count += 1
            
        }
    }
    
    private func newTimer(team: String, sender: BaseCell){
        
        teamHandler.stopwatchHandler.createMember(team: team, sender: sender)
    }
    
    //Used to maintain internal runner order when rows are rearranged
    private func didReorder(team: String){
        let rows = form.sectionBy(tag: team)?.allRows
        var list: [UIButton] = []
        
        for row in rows!{
            if(!row.baseCell.description.contains("Add New Runner")){
                let button = row.baseCell.subviews[1] as! UIButton
                list.append(button)
            }
            
        }
        buttonList[team] = list
        
    }
    
    
    
    //    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
    //        let myURL = url as URL
    //        print("import result : \(myURL)")
    //    }
    //
    //
    //    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
    //        documentPicker.delegate = self
    //        present(documentPicker, animated: true, completion: nil)
    //    }
    //
    //
    //    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    //        print("view was cancelled")
    //        dismiss(animated: true, completion: nil)
    //    }
    
    
    
    
    
    
}/// End class




