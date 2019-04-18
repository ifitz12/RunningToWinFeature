//
//  ViewController.swift
//  EurekaTester
//
//  Created by Ian Fitzgerald on 10/24/18.
//  Copyright © 2018 Ian Fitzgerald. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Teams", in: context)
            
        
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue("bob test", forKey: "member")
        newUser.setValue("red", forKey: "team")
       
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
    }


}

