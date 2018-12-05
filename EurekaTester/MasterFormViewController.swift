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
import FloatLabelRow


class MasterFormViewController: FormViewController, AlertsViewControllerDelegate{
    
    

    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var status: Int = 0
    var mainStopwatch: ButtonRow? = nil
    var masterView: MasterHomeViewController = MasterHomeViewController()
    var count: Int = 0
    let startColor = UIColor(hexString: "#7DFF8F")
    let pauseColor = UIColor(hexString: "#FDFF66")
    var teamName = "team1"
    var buttonList: [UIButton] = []

    
    @objc func startAction(sender: UIButton!) {
        if(sender.backgroundColor == .green){
            sender.backgroundColor = .red
            sender.setTitleColor(.white, for: .normal)
            sender.setTitle("STOP", for: .normal)
            sender.formCell()?.backgroundColor = startColor
            masterView.alerts.startTimer(runnerForm: sender)
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
            masterView.alerts.stopTimer(runnerForm: sender)
            
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
        masterView.alerts.addSplit(runnerForm: sender)
    }
    
    
    @objc func resetAction(sender: UIButton!){
        print("button tapped")
        self.reset(resetAll: true)
    }
    
    @objc func dataAction(sender: UIButton!) {
        
        let runner = masterView.alerts.currentRunner
        let splits = masterView.alerts.runners.getSplits(key: "team1")
        var masterString = ""
        print("splits = " + splits[0])
        
        for i in splits{
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
        print("HERE")
        print(masterString)
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLayoutSubviews()
        masterView.alerts.delegate = self
        var buttons = createButtons()
       
        buttons[2].setTitleColor(.black, for: .normal)
        buttons[3].setTitleColor(.black, for: .normal)
        animateScroll = true
        
        form +++
//            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
//                               header: "Multivalued TextField",
//                               footer: ".Insert adds a 'Add Item' (Add New Tag) button row as last cell.") {
//                                $0.addButtonProvider = { section in
//
//                                    return ButtonRow(){
//                                        $0.title = "Add New Tag"
//                                    }
//                                }
//                                $0.multivaluedRowToInsertAt = { index in
//                                    return NameRow() {
//                                        $0.placeholder = "Tag Name"
//                                    }
//                                }
//                                $0 <<< NameRow() {
//                                    $0.placeholder = "Tag Name"
//
//                                }
//
//
//            form = Section(teamName)
             SegmentedRow<String>("segments"){
                $0.options = ["Runners", "Stats"]
                $0.value = "Runners"
                $0.title = "Team 1:"
            }
            
            <<< SwitchRow("switch"){ row in
                row.title = "Relay"
                row.hidden = "$segments != 'Runners'"
                
                }.onChange{[weak self] row in
                    if(row.value == true){
                        row.title = "Relay started!"
                        //row.baseCell.addSubview(<#T##view: UIView##UIView#>)
                        row.updateCell()
                    }
                    else{
                        row.title = "Relay"
                        row.updateCell()
                    }
            }
            
            <<< ButtonRow(){ row in
                row.title = "Start Team 1"
                row.baseCell.addSubview(buttons[2])
                row.baseCell.addSubview(buttons[3])
                
                }.onCellSelection{[weak self] cell, row  in
                    
                    print("START CLICKED")
                    self?.mainStopwatch = row
                    if(self!.status == 1){
                        self?.stop()
                        
                        cell.textLabel?.textColor = UIColor.black
                        cell.backgroundColor = self!.pauseColor
                        buttons[2].backgroundColor = self!.pauseColor
                        buttons[3].backgroundColor = self!.pauseColor
                        
                    }
                    else if (self!.status == 0){
                        self?.start()
                        
                        cell.textLabel?.textColor = UIColor.black
                        cell.backgroundColor = self!.startColor
                        buttons[2].backgroundColor = self!.startColor
                        buttons[3].backgroundColor = self!.startColor
                    }
                }.cellUpdate({ cell, row in
                    
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
                    cell.textLabel?.textColor = .black
                    
                })
    
            
            +++  MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                                    header: "",
                                    footer: ""){
                                $0.hidden = "$segments != 'Runners'"
                                $0.tag = teamName
                                $0.showInsertIconInAddButton = false
                                
                                $0.addButtonProvider = { section in
                                    print(section.values())
                                    return ButtonRow(){ row in
                                        row.title = "Add New Runner"
                                        
                                        }
                                }
                            
                                // Telling the section where to insert the new row
                                $0.multivaluedRowToInsertAt = { index in
                                   
                                    return TextFloatLabelRow() { row in
                                        row.title = " "
                                        
                                        
                                        }.cellSetup{ cell, row in
                                            var buttons = self.createButtons()
                                            cell.addSubview(buttons[0])
                                            cell.addSubview(buttons[1])
                                            //cell.addSubview(buttons[3])
                                            cell.addSubview(buttons[4])
                                            self.buttonList.append(buttons[0])
                                            self.present(self.masterView.alerts.showNewRunnerDialog(cell: row.baseCell as! Cell<String>), animated: true, completion: nil)
                                            
                                        }.cellUpdate({ cell, row in
                                            
                                            cell.height = {80}
                                            cell.textField?.font = UIFont(name: "HelveticaNeue", size: 20.0)
                                            cell.textField?.textColor = .black
                                            
                                        })
                                    
                                        }
                }
                
//            +++ Section(){ section in
//                section.tag = "Button"
//                section.hidden = "$segments != 'Runners'"
//
//            }
//            <<< ButtonRow(){ row in
//                row.title = "Start Team 1"
//                row.baseCell.addSubview(buttons[2])
//                row.baseCell.addSubview(buttons[3])
//
//                }.onCellSelection{[weak self] cell, row  in
//
//                    print("START CLICKED")
//                    self?.mainStopwatch = row
//                    if(self!.status == 1){
//                        self?.stop()
//
//                        cell.textLabel?.textColor = UIColor.black
//                        cell.backgroundColor = self!.pauseColor
//                        buttons[2].backgroundColor = self!.pauseColor
//                        buttons[3].backgroundColor = self!.pauseColor
//
//                    }
//                    else if (self!.status == 0){
//                        self?.start()
//
//                        cell.textLabel?.textColor = UIColor.black
//                        cell.backgroundColor = self!.startColor
//                        buttons[2].backgroundColor = self!.startColor
//                        buttons[3].backgroundColor = self!.startColor
//                    }
//                }.cellUpdate({ cell, row in
//
//                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
//                    cell.textLabel?.textColor = .black
//
//                })
        
        
    }
       // }
    
//    func createSelectorRow(teamName: String) -> MultipleSelectorRow<String>{
//        return MultipleSelectorRow<String>() {
//            $0.title = teamName
//        }
//        
//    }
    
    
    /// A function to create buttons that will be used throughout the form
    ///
    /// - Returns: An array of UIButtons
    func createButtons() -> [UIButton]{
        
        let title = UIButton(frame: CGRect(x: 5, y: 5, width: 100, height: 30))
        let start = UIButton(frame: CGRect(x: 250, y: 10, width: 80, height: 25))
        let split = UIButton(frame: CGRect(x: 250, y: 45, width: 80, height: 25))
        let reset = UIButton(frame: CGRect(x:0 , y: 0, width: 100, height: 48))
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
        
        reset.setTitle("RESET", for: .normal)
        reset.addTarget(self, action: #selector(self.resetAction), for: .touchUpInside)
        reset.layer.borderWidth = 1.0
        reset.layer.borderColor = UIColor.black.cgColor
        
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
    
        return [start, split, reset, splitData, title]
        
    }
   
    func start() {
        masterView.alerts.startAll(runners: buttonList)

        self.startTime = Date().timeIntervalSinceReferenceDate - self.elapsed
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        // Set Start/Stop button to true
        self.status = 1
        
    }
    
    func stop() {
        masterView.alerts.stopAll(runners: buttonList)
        self.elapsed = Date().timeIntervalSinceReferenceDate - self.startTime
        self.timer?.invalidate()
        
        // Set Start/Stop button to false
        self.status = 0
        print(self.elapsed)
    }
    
    func reset(resetAll: Bool){
        if(resetAll){
        masterView.alerts.resetAll(runners: buttonList)
        }
        //Reseting timer attributes
        self.timer?.invalidate()
        weak var t: Timer?
        self.timer = t
        self.time = 0
        self.startTime = 0
        self.elapsed = 0
        self.status = 0
        
        mainStopwatch?.title = "00:00.00"
        mainStopwatch?.cell.backgroundColor = .white
        mainStopwatch?.updateCell()
    }
    
    @objc func update() {
        
        // Calculate total time since timer started in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        // Calculate minutes
        let minutes = UInt64(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt64(time)
        time -= TimeInterval(seconds)
        
        // Calculate milliseconds
        let milliseconds = UInt64(time * 100)
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMilliseconds = String(format: "%02d", milliseconds)
        
        let currentTime = strMinutes + ":" + strSeconds + "." + strMilliseconds
     
      
       mainStopwatch!.title = currentTime
       mainStopwatch?.reload()
        
        
    }
    
    
    
    ///DELEGATE METHODS
    
    func deleteFromButtonList(cell: Cell<String>) {
        for b in buttonList{
            if(b.formCell() == cell){
                buttonList.removeLast()
            }
        }
    }
    
    func animateStart(cell: Cell<String>) {
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
    
    
}
    

    

