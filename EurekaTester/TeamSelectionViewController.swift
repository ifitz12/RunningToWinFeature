//
//  TeamSelectionViewController.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 4/7/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class TeamSelectionViewController: FormViewController, UITextViewDelegate{
  
    @IBOutlet weak var submitButton: UIButton!
    
    var teams: [String] = []
    var members: [String: [String]] = [:]
    var textView: UITextView = UITextView()
    var multiRowInFocus: MultipleSelectorRow<String> = MultipleSelectorRow<String>()
    let membersAlertController = UIAlertController(title: "Add Members \n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
    let newTeamAlertController = UIAlertController(title: "New Team", message: "", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        setUpButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.getTeamList), name: NSNotification.Name(rawValue: "sendTeams"), object: nil)
      
    }
    
    func setUpButton(){
        view.bringSubviewToFront(submitButton)
        submitButton.backgroundColor = .orange
        submitButton.removeTarget(nil, action: nil, for: .allEvents)
        submitButton.addTarget(self, action: #selector(self.p), for: .touchUpInside)
         submitButton.setTitleColor(.black, for: .normal)
         submitButton.titleLabel?.font = .systemFont(ofSize: 20)
         submitButton.layer.cornerRadius = 15
         submitButton.clipsToBounds = true
       
        
    }
    
    func getRunnersByTeam(members: [String]) {
        
        for t in teams{
            self.members[t] = members
        }
        
    }
    
    @objc func p(){
        print("HEY HEY")
        
    }
    
    ///Delegate methods
    @objc func getTeamList(_ n: Notification) {
       
        print("IN CONTROLLER")
     
        self.members = n.object as! [String:[String]]
        self.teams = Array(members.keys)
        
        
        form +++ createExistingRows()
        form +++ createLocalTeams()
        
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopSpinner"), object: nil, userInfo: nil)
    }
    
   
    
    func createExistingRows() -> Section{
        
        let section = Section("Existing Teams")
        //section.header?.title = "Existing Teams"
      
        for t in teams{
            
            var options: [String] = []
            for member in members[t]!{
                options.append(member)
            }
            
        section <<< MultipleSelectorRow<String> { row in
            row.title = t
            row.options = options
            
            }.onChange({ row in
                
                if (row.value != nil && !(row.value?.isEmpty)!){
                 
                    row.baseCell.backgroundColor = Colors.startColor
                }
                else{
                    row.baseCell.backgroundColor = UIColor.white
                }
                
        
            })
            
        }
            
       return section
    
        
    }
    
    func createLocalTeams() -> Section{
        
        let section = Section()
        let localTeams = Section("Local Teams")
        section <<< ButtonRow(){ row in
            
            row.title = "Add New Local Team"
            self.setUpAddMembersAlertController()
            self.setUpNewTeamAlertController(section: section, team: localTeams)
            
            }.onCellSelection({ row, cell in
         
               self.present(self.newTeamAlertController, animated: true, completion: nil)
            })
    
        return section
    }
    
    
    func setUpTextView(alert: UIAlertController){
        
        let xMargin: CGFloat = 10.0
        let yMargin: CGFloat = 40.0
        let rect = CGRect(x: xMargin, y: yMargin, width: alert.view.bounds.size.width - 24.0*5, height: 150.0)
        self.textView.frame = rect
        
        self.textView.backgroundColor = UIColor.clear
        self.textView.font = UIFont(name: "ChalkboardSE-Regular", size: 18)
        
        self.textView.text = "Mike Stahr, Ian Fitzgerald"
        self.textView.textColor = UIColor.lightGray
        
        
    }
    
    func setUpAddMembersAlertController(){
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            let text = self.textView.text
            let newMembers = self.parseNewMembers(text: text!)
            self.multiRowInFocus.options = newMembers
        
            
            
            self.textView.text.removeAll()
            self.textView.text = "Mike Stahr, Ian Fitzgerald"
            self.textView.textColor = UIColor.lightGray
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        
        self.setUpTextView(alert: membersAlertController)
        
        self.membersAlertController.addAction(confirmAction)
        self.membersAlertController.addAction(cancelAction)
        
       
        self.membersAlertController.view.addSubview(self.textView)
        
    }
    
    func setUpNewTeamAlertController(section: Section, team: Section){
       
    
        
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            let multiRow = MultipleSelectorRow<String>{row in
                 row.title = self.newTeamAlertController.textFields?[0].text
                }.onChange({ row in
                    
                    if (row.value != nil && !(row.value?.isEmpty)!){
                        row.baseCell.backgroundColor = Colors.startColor
                    }
                    else{
                        row.baseCell.backgroundColor = UIColor.white
                    }
                })
            
            self.newTeamAlertController.textFields?[0].text?.removeAll()
            self.newTeamAlertController.textFields?[0].placeholder = "Team Name"
            self.newTeamAlertController.textFields?[0].addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            //multiRow.title = self.newTeamAlertController.textFields?[0].text
            self.multiRowInFocus = multiRow
            if(team.allRows.count == 0){
                
                self.form.insert(team, at: section.index!)
                team <<< multiRow
            }
            else{
                
                do{try team.insert(row: multiRow, after: team.allRows.last!)}
                catch let error as NSError{
                    print("Error in adding row")
                }
            }
            self.present(self.membersAlertController, animated: true, completion: nil)
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in }
        
        confirmAction.isEnabled = false
        self.newTeamAlertController.addTextField { (textField) in
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            textField.placeholder = "Team Name"
        }
        self.newTeamAlertController.addAction(cancelAction)
        self.newTeamAlertController.addAction(confirmAction)
        
        
    }
    
    
    func parseNewMembers(text: String) -> [String]{
        let replace = text.replacingOccurrences(of: ".", with: "")
        let split = replace.components(separatedBy: ",")
        var list: [String] = []
        for s in split{
            let trim = s.trimmingCharacters(in: [" "])
            list.append(trim)
        }
        
        
        return list
    }
    
    func isValidInput(text: String) -> Bool{
        let charset = CharacterSet(charactersIn: "!@#$%^&*()+=?/<>|[]{}")
        let trim = text.trimmingCharacters(in: [" "])
        let split = trim.split(separator: ",")
        
        if (text.rangeOfCharacter(from: charset) == nil && text != "") {
            print("yes")
            
            for s in split{
                let space = s.split(separator: " ")
                
                if(space.count != 2 && !s.isEmpty){
                    return false
                }
            }
            return true
        }
        else{
            return false
        }
    }
    
    
    
    ///DELEGATE METHODS
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textView.text = ""
        self.textView.textColor = UIColor.black
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text
        membersAlertController.actions.first?.isEnabled = self.isValidInput(text: text!)
        
    }
    
    @objc func textFieldDidChange(_ textView: UITextView) {
        self.newTeamAlertController.actions.last?.isEnabled = !textView.text.isEmpty
        
    }
    
    
}



