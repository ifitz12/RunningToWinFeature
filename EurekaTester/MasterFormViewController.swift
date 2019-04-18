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


class MasterFormViewController: FormViewController, AlertsViewControllerDelegate {
   
    
   
    //UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate{
    
    var masterView: MasterHomeViewController = MasterHomeViewController()
    var teamHandler: TeamHandler = TeamHandler()
    var relayEngine: RelayEngine = RelayEngine()
    var teamData: TeamData = TeamData()
    var teams: [String] = []
    var buttonList: [String: [UIButton]]  = [:]
    var segmentedTags: [String: String] = [:]
    var relayRow: SegmentedRow<String> = SegmentedRow<String>()
  
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
      
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FORM LOADED")
       
        tableView.isEditing = false
        animateScroll = true
        //automaticallyAdjustsScrollViewInsets = false
        //tableView?.contentInset = UIEdgeInsets(top: -18, left: 0, bottom: 0, right: 0)
        masterView.alerts.delegate = self
        
        self.form = Form()
     
        
        //Observers for
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData), name: NSNotification.Name(rawValue: "updateData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.newTeam), name: NSNotification.Name(rawValue: "newTeamSender"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetForm), name: NSNotification.Name(rawValue: "resetForm"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.editForm), name: NSNotification.Name(rawValue: "editSender"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentSave), name: NSNotification.Name(rawValue: "saveOption"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeAddRunner), name: NSNotification.Name(rawValue: "removeAddRunner"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeDuplicate), name: NSNotification.Name(rawValue: "duplicateRunner"), object: nil)
        
    
        
        var buttons = createButtons()
        buttons[2].setTitleColor(.black, for: .normal)
        buttons[3].setTitleColor(.black, for: .normal)
    }
    
    
    
    @objc func startAction(sender: UIButton!) {
        
        let team = sender.formCell()?.baseRow.section!.tag
        
        if(sender.backgroundColor == .green){
            sender.backgroundColor = Colors.stopColor
            sender.setTitleColor(.white, for: .normal)
            sender.setTitle("STOP", for: .normal)
            sender.formCell()?.backgroundColor = Colors.startColor
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
            sender.formCell()?.backgroundColor = Colors.pauseColor
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
           
            $0.value = "Timer"
          
            
            }
        
        <<< DoublePickerInlineRow<String, String>(tag3) {
            $0.title = "Relay Type"
            $0.firstOptions = { return ["4"]}
            $0.secondOptions = { _ in return ["x 100", "x 200", "x 400"]}
            $0.value = Tuple(a: "4", b: "x 100")
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
                  
                    
                    if let relayType = self!.form.rowBy(tag: tag3)?.baseValue as? Tuple<String, String>{
                        
                        let type = relayType.a + " " + relayType.b
                        if (runnerCount != 4) {
                            self?.present(self!.relayEngine.relaySizeError(), animated: true, completion: nil)
                            row.value = false
                            row.updateCell()
                        }
                        else if(row.value == true){
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startRelay"), object: self!.teamHandler, userInfo: ["name": teamName, "segment": self!.form.rowBy(tag: tag2) as Any, "list": self!.buttonList[teamName]! , "type": type as Any, "switch": self!.form.rowBy(tag: tag1) as Any] as [AnyHashable : Any])
                            
                            if let segmentedRow = self!.form.rowBy(tag: tag2){
                                segmentedRow.hidden = true
                                segmentedRow.evaluateHidden()
                            }
                            
                            self!.form.rowBy(tag: tag2)?.updateCell()
                            row.title = "Relay started! " + (type as! String)
                            row.updateCell()
                            
                            self?.didReorder(team: teamName)
                            
                        }
                            
                        else{
                            
                            if let segmentedRow = self!.form.rowBy(tag: tag2) as? SegmentedRow<String>{
                                segmentedRow.hidden = false
                                segmentedRow.evaluateHidden()
                                self!.form.sectionBy(tag: teamName)?.allRows[4].hidden = false
                                self!.form.sectionBy(tag: teamName)?.allRows[4].evaluateHidden()
                            
                                self?.teamData.createRunnerDataCells(forTeam: teamName, rowTag: tag2, dataSet: self!.teamHandler)
                                
                                //form.a <<< rows[0]
                                //self?.updateData(row: segmentedRow)
                                
                                self?.relayRow = segmentedRow
                                //NotificationCenter.default.addObserver(self!, selector: #selector(self!.updateData), name: NSNotification.Name(rawValue: "updateData"), object: segmentedRow)
                                //self!.form.insert(self!.teamData.getSection(), at: ((segmentedRow.indexPath?.row)!+2))
                                //segmentedRow.updateCell()
                            }
                            
                            row.title = "Relay:"
                            row.updateCell()
                        }
                    }
                    
                    
            }
            
            
            <<< ButtonRow(tag4){ row in
                row.tag = teamName
                row.hidden = Condition(stringLiteral: "$\(tag2) != 'Timer'")
                row.title = "Start All"
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
                    
                    cell.backgroundColor == Colors.startColor ? self?.stopAllTeam(team: teamName) : self?.startAllTeam(team: teamName)
                    
                    cell.textLabel?.textColor = UIColor.black
                    
                }.cellUpdate({ cell, row in
                    row.tag = teamName
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
                    cell.textLabel?.textColor = .black
                    
                })
        
        
        
        
       
        
        var header = HeaderFooterView<UILabel>(.class)
        header.onSetupView = {view, _ in
           
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: 400, height: 30))
            label.text = teamName
            label.font = UIFont(name: "Arial Rounded MT Bold", size: 22)
            view.addSubview(label)
          
        }
        header.height = {30.0}
        section.header = header
        
        
        
        return section
        
    }
    
    private func createMultivaluedSection(teamName: String) -> Section{
        let switchTag = teamName.replacingOccurrences(of: " ", with: "") + "seg"
        let section = MultivaluedSection(multivaluedOptions: [.Reorder, .Insert],
                                         header: "",
                                         footer: ""){
                                            $0.header?.height = { CGFloat.leastNormalMagnitude }
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
        //width 80, height 25
        let start = UIButton(frame: CGRect(x: 230, y: 10, width: 60, height: 60))
        let split = UIButton(frame: CGRect(x: 300, y: 10, width: 60, height: 60))
        //let reset = UIButton(frame: CGRect(x:0 , y: 0, width: 100, height: 48))
        let splitData = UIButton(frame: CGRect(x:275 , y: 0, width: 100, height: 48))
        
        //Setting up positions for animations
        title.center.x -= view.bounds.width
        start.center.x += view.bounds.width
        split.center.x += view.bounds.width
        
        start.backgroundColor = .green
        start.setTitle("GO", for: .normal)
        start.setTitleColor(.black, for: .normal)
        start.titleLabel?.font = .systemFont(ofSize: 14)
        start.layer.cornerRadius = 10
        start.clipsToBounds = true
        start.addTarget(self, action: #selector(self.startAction), for: .touchUpInside)
        
        split.backgroundColor = .blue
        split.setTitle("Split", for: .normal)
        split.titleLabel?.font = .systemFont(ofSize: 15)
        split.layer.cornerRadius = 10
        split.clipsToBounds = true
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
    
    func createRunnerRow(teamName: String) -> BaseRow{
        
       let runnerRow =  LabelRow() { row in
            row.title = " "
            
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
                
                
                //Handling button list additions
                if(self.buttonList[teamName] == nil){
                    self.buttonList[teamName] = [buttons[0]]
                }
                else{
                    self.buttonList[teamName]?.append(buttons[0])
                }
                
                //Animating button appearence
//                self.present(self.masterView.alerts.showNewRunnerDialog(cell: row.baseCell as! Cell<String>), animated: true, completion: nil)
//                
                //Adjusting cell size
            }.cellUpdate({ cell, row in
                cell.height = {80}
                
                
            })
        
        return runnerRow
    }
    
    
    ///DELEGATE AND NOTIFICATION METHODS
    
    @objc func resetForm(){
        print("FORM RESET")
        
        self.form.removeAll()
    }
    
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

    
    
    @objc func updateData(){
        print("UPDATE DATA")
       // let segmentedRow = n.object as! SegmentedRow<String>
        print(self.teamData.getSection())
        self.form.insert(self.teamData.getSection(), at: (self.relayRow.indexPath?.row)!+2)
    }
    
    
    @objc func removeAddRunner(n:Notification){
        
        let tag = n.object as! String
        
        self.form.sectionBy(tag: tag)?.allRows[4].hidden = true
        self.form.sectionBy(tag: tag)?.allRows[4].evaluateHidden()
        //f!.allRows[4].hidden = true
        //f?.allRows[4].baseCell.update()
        
    }
    
    @objc func newTeam(_ n: Notification) {
        
        let allData = n.userInfo as? [String:[String]]
       
        
        for team in allData!{
            let name = team.key
            let members = team.value
            self.form +++ addSection(teamName: name)
            self.form +++ createMultivaluedSection(teamName: name)
            var section = self.form.sectionBy(tag: name)
            
            for i in 0...members.count-1{
                let memberName = members[i].split(separator: " ")
                let row = createRunnerRow(teamName: name)
                row.title = "00:00.00"
                row.baseCell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)
                
                (row.baseCell.subviews[3] as? UIButton)?.setTitle(memberName[0].capitalized + " " + String(memberName[1].first!).capitalized + ".", for: .normal)
                section?.insert(row, at: i)
                
                self.animateSplit(cell: row.baseCell as! Cell<String>)
                self.animateStart(cell: row.baseCell as! Cell<String>)
                self.animateTitle(cell: row.baseCell as! Cell<String>)
                self.newRunner(firstName: String(memberName[0]).lowercased(), lastName: String(memberName[1]).lowercased(), membership: (row.section?.tag!)!, cell: row.baseCell)
                row.baseCell.update()
        }
  
//            let alert = n.object as! UIAlertController
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                alert.dismiss(animated: true, completion: nil)
//            }
        }
    }
    
    
    @objc func presentSave(_ n:Notification) {
        let controller = n.object as! UIAlertController
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @objc func removeDuplicate(_ n: Notification) {
        
        let cell = n.object as! BaseCell
        let team = n.userInfo!["team"] as! String
        let button = cell.subviews[1] as! UIButton
      
        self.removeFromButtonList(button: button, team: team)
        
        
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
    
    
    
    func removeRunner(teamName: String, cell: BaseCell) {
        let button = cell.subviews[1] as! UIButton
        
        
        //self.teamHandler.runnnerHandlers[teamName]?.removeFromTimerList(runner: buttons[3])
        
        self.removeRunner(membership: teamName, row: cell.baseRow)
        
        self.removeFromButtonList(button: button, team: teamName)
        
        self.removeCell(cell: cell)
        self.didReorder(team: teamName)
    }
    
    
    func animateSplit(cell: Cell<String>) {
        
        UIView.animate(withDuration: 0.7, delay: 0.1,
                       usingSpringWithDamping: 0.77,
                       initialSpringVelocity: 0.3,
                       options: [], animations: {
                        cell.subviews[2].center.x -= self.view.bounds.width
                        
        }, completion: nil)
    }
    
    func animateStart(cell: Cell<String>) {
        
        UIView.animate(withDuration: 0.7, delay: 0,
                       usingSpringWithDamping: 0.77,
                       initialSpringVelocity: 0.3,
                       options: [], animations: {
                        cell.subviews[1].center.x -= self.view.bounds.width
                        
        }, completion: nil)
        
        
    }
    
    func animateTitle(cell: Cell<String>){
        
        UIView.animate(withDuration: 0.8, delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.3,
                       options: [], animations: {
                        cell.subviews[3].center.x += self.view.bounds.width
                        
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

    
    
    
}/// End class




