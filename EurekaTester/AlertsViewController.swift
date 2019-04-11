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
    //func deleteFromButtonList(cell: Cell<String>)
    func animateStart(cell: Cell<String>)
    func animateSplit(cell: Cell<String>)
    func animateTitle(cell: Cell<String>)
    func newRunner(firstName: String, lastName: String, membership: String, cell: BaseCell)
    func removeRunner(teamName: String, cell: BaseCell)
    
    
}


class AlertsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    var typeValue = String()
    var choices: [String] = []
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        return choices[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        typeValue = choices[row]
        
        
    }
    
    
    
    weak var delegate: AlertsViewControllerDelegate?
  
    var teamName: String = ""
    var firstName: String = ""
    var lastName: String = ""
  
    //var API: APIEngine = APIEngine()
    var pickerValue = ""
    var teamList: [String] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
  
    func initialize(){
        //API.request()
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
                

                cell.baseRow.title = "00:00.00"
                cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)
    
                DispatchQueue.main.async {
                    self.delegate?.animateStart(cell: cell)
                    self.delegate?.animateSplit(cell: cell)
                    self.delegate?.animateTitle(cell: cell)
                }
                self.delegate?.newRunner(firstName: self.firstName, lastName: self.lastName, membership: (cell.baseRow.section?.tag!)!, cell: cell)
                cell.update()
            }
        }
        
        //the cancel action removing runner cell
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.delegate?.removeRunner(teamName: (cell.baseRow.section?.tag!)!, cell: cell)
  
        }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            confirmAction.isEnabled = false
            textField.placeholder = "Full Name"
            textField.addTarget(alertController, action: #selector(alertController.textDidChangeInLoginAlert), for: .editingChanged)
        }

        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        //confirmAction.isEnabled = false
        
        //finally presenting the dialog box
        return alertController
    }

    
    
    /// Presenting the new team dialog box
    func showNewTeamDialog() -> UIAlertController{
        //self.API.requestTeamList()
        let alertController = UIAlertController(title: "New Team", message: "", preferredStyle: .alert)
  
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            self.teamName = (alertController.textFields?[0].text)!
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newTeamSender"), object: nil, userInfo: [self.teamName: (Any).self])
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Team Name"
        }
        
        let importAction = UIAlertAction(title: "Import", style: .default) { (_) in
            
           
           // self.choices = self.API.getTeamList()
                let alert = UIAlertController(title: "Teams", message: "\n\n\n\n\n\n", preferredStyle: .alert)
                alert.isModalInPopover = true
                
                let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
            
                alert.view.addSubview(pickerFrame)
                pickerFrame.dataSource = self
                pickerFrame.delegate = self
                pickerFrame.delegate?.pickerView!(pickerFrame, didSelectRow: 0, inComponent: 0)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                    
                    
                }))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    
                   
                        print("got here")
                    self.teamName = self.typeValue.capitalized
                  //  self.API.requestTeamMembers(teamName: self.typeValue)
                    
                    let alert = UIAlertController(title: nil, message: "Importing team...", preferredStyle: .alert)
                    
                    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                    loadingIndicator.hidesWhenStopped = true
                    loadingIndicator.style = UIActivityIndicatorView.Style.gray
                    loadingIndicator.startAnimating();
                    
                    alert.view.addSubview(loadingIndicator)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: {
                      //  print(self.API.getTeamMembers())
                     
                      //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newTeamSender"), object: alert, userInfo: ["team": self.typeValue.capitalized, "members": self.API.getTeamMembers()])
                        
                    })
                    
    
                    
                }))

                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
          
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.addAction(importAction)
        
        return alertController
    }
    
    
    
    
    func newTeamName() -> String {
        return self.teamName
    }
}



// Input validation
//extension UIAlertController {
//
//    func isFullName(name: String) -> Bool{
//      
//        let fname = name.split(separator: " ")
//        if (fname.count != 0 && fname.count > 1 && fname.count < 3){
//        return true
//        }
//        else{
//            return false
//        }
//    }
//
//    @objc func textDidChangeInLoginAlert() {
//       let name =  (textFields?[0].text)
//
//            let action = actions.first
//    action?.isEnabled = isFullName(name: name!)
//
//    }
//    
//}
    
    
    

