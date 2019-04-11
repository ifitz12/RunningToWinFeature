//
//  APIEngine.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 3/18/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol APIEngineDelegate: class {
    func successLogin()
    func failureLogin(error: Bool)
    
}

class APIEngine{
    
    var login: [String: String] =
        ["vendorId": "d2e09e0c-a214-4079-b0f5-4cc5aeb19a61",
         "appId": "5c85a799-a2fd-4202-b30c-ff350f0f5f57"]
        // "userNameOrEmail": "ifitz",
        // "password": "test1234"]
    
    var token: String = ""
    var teamTokens: [String: String] = [:]
    var teamMembers: [String: [String]] = [:]
    var valid: Bool = false
    var queue: DispatchQueue = DispatchQueue(label: "API")
    weak var delegate: APIEngineDelegate?
    
    func request(){
        print("request sent")
       // var error: NSDictionary = [:]
        Alamofire.request("https://r2wmobile4.running2win.com/api.asmx/login", method: .post, parameters : login)
            
            .responseJSON { response in
                if let error = response.result.value as? NSDictionary{
                switch error["errorCode"] as! Int {
                case 0:
                    let json = response.result.value as! NSDictionary
                    self.token = json["token"]! as! String
                    print(self.token)
                    self.delegate?.successLogin()
                    
                case 1:
                    print(error)
                    self.delegate?.failureLogin(error: false)
                    
                default:
                    print("error")
                    
                    }
                }
                else{
                    self.delegate?.failureLogin(error: true)
                    let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                   let alert =  UIAlertController(title: "Network error", message: "A connection to the server cannot be made", preferredStyle: .alert)
                    alert.addAction(action)
                     UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                
        }
      
    }
    
    func getStatus() -> Bool{
        print(valid)
        return valid
    }
    
    func requestTeamList(){
        print("team list requested")
        Alamofire.request("https://r2wmobile4.running2win.com/api.asmx/getTeamList", method: .post, parameters : ["token": self.token])
            
            .responseJSON { response in
                
               
                if let teamArray = response.result.value as? NSArray{
                
                for i in 0...teamArray.count-1{
                    let dict = teamArray[i] as! NSDictionary
                    self.teamTokens[dict["teamName"]! as! String] = dict["teamToken"]! as? String
                    
                }
                }
          
                
        }
       
    }
    
    func requestTeamMembers(teamName: String, completion: (() -> Void)?){
        
        //queue.async {
        Alamofire.request("https://r2wmobile4.running2win.com/api.asmx/getTeamMembers", method: .post, parameters : ["token": self.token, "teamToken": self.teamTokens[teamName]!])
            
            .responseJSON { response in
                
               
                let runnerArray = response.result.value as! NSArray
                
                
                for i in 0...runnerArray.count-1 {
                    let dict = runnerArray[i] as! NSDictionary
                    let str = (dict["FirstName"] as! String) + " " + (dict["LastName"] as! String)
                    if(i == 0){
                        
                        self.teamMembers[teamName] = [str]
                    }
                    else{
                        self.teamMembers[teamName]!.append(str)
                    }
                    
                }
                
                print("finished request")
                completion!()
            }
      //  }
        
        
      //  print("members requested")
        
    }
    

    func getTeamList() -> [String]{
        
        return Array(self.teamTokens.keys)
        
    }
    
    func getTeamMembers(team: String) -> [String]{
      
        return self.teamMembers[team]!
    }
    
}
