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
    func newRunner(firstName: String, lastName: String, membership: String, cell: BaseCell)
}

//protocol AlertsViewControllerRunnerDelegate {
//    func newRunner(firstName: String, lastName: String, membership: String, cell: BaseCell)
//}


class AlertsViewController: UIViewController{

    var delegate: AlertsViewControllerDelegate?
    //var runnerDelegate: AlertsViewControllerRunnerDelegate?
    
    var teamName: String = ""
    var firstName: String = ""
    var lastName: String = ""
  
    
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
                cell.baseRow.title = "00:00.00"
                cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)
                //start.titleLabel?.font = .systemFont(ofSize: 12)
                //cell.baseRow.baseValue = "00:00.00"
               
                self.delegate?.animateStart(cell: cell)
                self.delegate?.animateSplit(cell: cell)
                self.delegate?.newRunner(firstName: self.firstName, lastName: self.lastName, membership: (cell.baseRow.section?.tag!)!, cell: cell)
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
    
    
    

