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
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var teams: [String] = []
    var members: [String: [String]] = [:]
    
    var textView: UITextView = UITextView()
    var multiRowInFocus: MultipleSelectorRow<String> = MultipleSelectorRow<String>()
    let membersAlertController = UIAlertController(title: "Add Members \n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
    let newTeamAlertController = UIAlertController(title: "New Team", message: "", preferredStyle: .alert)
    var teamInFocus: String = ""
    var localTeams: Section = Section("Local Teams")
    var baseRows: [BaseRow] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        setUpSubmitButton()
        setUpLogoutButton()

//        let defaults = UserDefaults.standard.dictionaryRepresentation().keys
//        for d in defaults{
//
//            UserDefaults.standard.removeObject(forKey: d)
//
//        }
//        
//        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getTeamList), name: NSNotification.Name(rawValue: "sendTeams"), object: nil)
      
    }
    
    func setUpSubmitButton(){
        view.bringSubviewToFront(submitButton)
        submitButton.backgroundColor = .orange
        submitButton.removeTarget(nil, action: nil, for: .allEvents)
         submitButton.setTitleColor(.black, for: .normal)
         submitButton.titleLabel?.font = .systemFont(ofSize: 20)
         submitButton.layer.cornerRadius = 15
         submitButton.clipsToBounds = true
        submitButton.addTarget(self, action: #selector(self.showTimer), for: .touchUpInside)
       self.navigationController?.navigationBar.barTintColor = Colors.navBarColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Arial Rounded MT Bold", size: 20)!]
     
        
    }
    
    func setUpLogoutButton(){
        logoutButton.target = self
        logoutButton.action = #selector(self.logout)
        
    }
    
    @objc func logout(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil, userInfo: nil)
        self.form.removeAll()
        multiRowInFocus = MultipleSelectorRow<String>()
        teams = []
        members = [:]
        teamInFocus = ""
        localTeams = Section("Local Teams")
        baseRows = []
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func getRunnersByTeam(members: [String]) {
        //var count = 0
        for t in teams{
            self.members[t] = members
            //self.members2[t][count] = members
            //count++
        }
        
    }
    
    @objc func showTimer(){
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil, userInfo: nil)
       
  
        var selectedTeams: [String: [String]] = [:]
        for value in form.allRows{
            
            if let set = value.baseValue as? NSSet{
                if(set.count != 0){
                selectedTeams[value.title!] = Array(set) as? [String]
                }
            }
            
        }
        

        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MasterHomeVC") as? MasterHomeViewController{
        
            self.navigationController?.pushViewController(viewController: vc, animated: true, completion: ({
                print("selected teams")
                print(selectedTeams)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newTeamSender"), object: nil, userInfo: selectedTeams)
                
//                for team in selectedTeams{
//                    let sender: [String:[String]] = [team.key: team.value]
//
//                    vc.newImport(userSelections: sender)
//
//
//                }
                
                }))
           
            
             
            }
        
        
    }
    
    
    
    ///Delegate methods
    @objc func getTeamList(_ n: Notification) {
        
        print("IN CONTROLLER")
        
        self.members = n.object as! [String:[String]]
        //self.members2 = n.object as! [String: [String: String]]
        self.teams = Array(members.keys)
        print(self.teams)
        let buttonSec = createLocalTeams()
        form +++ createExistingRows()
        form +++ buttonSec
        if(UserDefaults.standard.object(forKey: "Teams") != nil){
            localTeams = loadLocalTeams(buttonSection: buttonSec)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopSpinner"), object: nil, userInfo: nil)
    }
    
    
    
    func createExistingRows() -> Section{
        print("CALLED")
        let section = Section("Imported Teams")
        let buttonSection = Section()
        buttonSection <<< ButtonRow{ row in
            row.title = "Select All"
        }
        
        for t in teams{
            var options: [String] = []
            
            for member in members[t]!{
                options.append(member)
            }
            section <<< createMultipleSelectorRow(team: t, members: options, section: buttonSection)
        }
        
        return section
    }
    
    func createLocalTeams() -> Section{
        
        print("CREATE LOCAL CALLED")
        let section = Section()
        // let localTeams = Section("Local Teams")
        section <<< ButtonRow(){ row in
            
            row.title = "Add New Local Team"
            self.setUpAddMembersAlertController()
            self.setUpNewTeamAlertController(buttonSection: section)
            print("subviews")
            //print(self.view.)
            
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
            
            // self.multiRowInFocus
            
            self.textView.text.removeAll()
            self.textView.text = "Mike Stahr, Ian Fitzgerald"
            self.textView.textColor = UIColor.lightGray
            
            
            let defaults = UserDefaults.standard
            
            if(defaults.object(forKey: "Teams") == nil){
                print("here 1")
                defaults.set(self.teamInFocus, forKey: "Teams")
                
            }
            else if let teams = defaults.object(forKey: "Teams") as? [String]{
                print("here 2")
                var storedTeams = teams
                storedTeams.append(self.teamInFocus)
                defaults.set(storedTeams, forKey: "Teams")
                
                
            }
            else{
                 print("here 3")
                let storedTeams = defaults.object(forKey: "Teams") as! String
                var add: [String] = [storedTeams]
                add.append(self.teamInFocus)
                defaults.set(add, forKey: "Teams")
                
            }
            
            defaults.set(newMembers, forKey: self.teamInFocus)
            defaults.synchronize()
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in }

        self.setUpTextView(alert: membersAlertController)
        self.membersAlertController.addAction(confirmAction)
        self.membersAlertController.addAction(cancelAction)
        self.membersAlertController.view.addSubview(self.textView)
        
    }
    
    func setUpNewTeamAlertController(buttonSection: Section){
        
        let section = Section()
        
        section <<< ButtonRow{ row in
            row.title = "Select All"
            
            
        }
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            let team = self.newTeamAlertController.textFields?[0].text
            self.teamInFocus = team!
            let multiRow = self.createMultipleSelectorRow(team: team!, members: [""], section: section)

            self.newTeamAlertController.textFields?[0].text?.removeAll()
            self.newTeamAlertController.textFields?[0].placeholder = "Team Name"
            self.newTeamAlertController.textFields?[0].addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            //multiRow.title = self.newTeamAlertController.textFields?[0].text
            self.multiRowInFocus = multiRow
            
            if(self.localTeams.allRows.count == 0){
                
                self.form.insert(self.localTeams, at: buttonSection.index!)
                self.localTeams <<< multiRow
             
            }
            else{
                
                do{try self.localTeams.insert(row: multiRow, after: self.localTeams.allRows.last!)}
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
    
    
    func loadLocalTeams(buttonSection: Section) -> Section{

        let defaults = UserDefaults.standard
        let section = Section()
        var members: [String] = []
        section <<< ButtonRow{ row in
            row.title = "Select All"
            
            }
        
        
        if let team = defaults.object(forKey: "Teams") as? String{
            
            if let check = defaults.object(forKey: team) as? [String]{
                members = check
            }
            else if let check = defaults.object(forKey: team) as? String{
                members = [check]
            }
            print(members)
              let multiRow = createMultipleSelectorRow(team: team, members: members, section: section)

            self.form.insert(self.localTeams, at: buttonSection.index!)
            self.localTeams <<< multiRow
        
        }
        
        
        
      else if let teams = defaults.object(forKey: "Teams") as? [String]{
           
            for t in teams{
                let singleTeam = defaults.object(forKey: t) as! [String]
                let multiRow = createMultipleSelectorRow(team: t, members: singleTeam, section: section)

                if(self.localTeams.allRows.count == 0){
                    
                    self.form.insert(self.localTeams, at: buttonSection.index!)
                    self.localTeams <<< multiRow
                    
                }
                else{
                    
                    do{try self.localTeams.insert(row: multiRow, after: self.localTeams.allRows.last!)}
                    catch let error as NSError{
                        print("Error in adding row")
                        
                    }
                }
            }
        }
        
        return localTeams
    }
    
    
    func createMultipleSelectorRow(team: String, members: [String], section: Section) -> MultipleSelectorRow<String>{
        
        
        let multiRow = MultipleSelectorRow<String>(){row in
            row.title = team
            row.options = members
            row.selectorTitle = team
            self.baseRows.append(row)
            }.cellSetup({ cell, row in
                
                cell.textLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
                
                
            }).onCellSelection({ cell ,row in
                self.multiRowInFocus = row
                print("THREE")
                
            }).onChange({ row in
                
                if (row.value != nil && !(row.value?.isEmpty)!){
                    row.baseCell.backgroundColor = Colors.startColor
                    
                }
                else{
                    row.baseCell.backgroundColor = UIColor.white
                }
                
                
            }).onPresent({ from, to in
                
                let button = section.allRows.first as! ButtonRow
                button.onCellSelection({[weak self] cell, row  in
                    var set: Set<String> = []
                    for row in to.form.allRows{
                        if(row.title != "Select All"){
                            row.baseValue = row.title
                            row.baseCell.update()
                            set.insert(row.baseValue as! String)
                            
                        }
                    }
                    
                    self?.multiRowInFocus.value = set
                    
                    
                    
                })
                to.form.insert(section, at: 0)
                
                to.selectableRowCellSetup = { cell, row in
                    cell.tintColor = .red
                    
                }
            })
        
        
        return multiRow
    }
    
    
    @objc func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    func parseNewMembers(text: String) -> [String]{
        let replace = text.replacingOccurrences(of: ".", with: "")
        let trimming = replace.trimmingCharacters(in: [" "])
        let split = trimming.components(separatedBy: ",")
        var list: [String] = []
        for s in split{
            
            if(s != ""){
                let trim = s.trimmingCharacters(in: [" "])
                list.append(trim)
            }
        }
        
        return list
    }
    
    func isValidInput(text: String) -> Bool{
        let charset = CharacterSet(charactersIn: "!@#$%^&*()+=?/<>|[]{}")
        let trim = text.trimmingCharacters(in: [" "])
        let split = trim.split(separator: ",")
        
        if (text.rangeOfCharacter(from: charset) == nil && text != "" && text != "Mike Stahr, Ian Fitzgerald") {
           
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
    
    
    
    
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
    
    
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



extension UINavigationController {
    
    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
}

