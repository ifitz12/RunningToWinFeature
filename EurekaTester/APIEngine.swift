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


class APIEngine{
    
    let login: [String: String] =
        ["vendorId": "d2e09e0c-a214-4079-b0f5-4cc5aeb19a61",
         "appId": "5c85a799-a2fd-4202-b30c-ff350f0f5f57",
         "userNameOrEmail": "ifitz",
         "password": "test1234"]
    
    var token: String = ""
    var teamTokens: [String: String] = [:]
    var teamMembers: [String] = []
    
    
    func request(){
        Alamofire.request("https://r2wmobile4.running2win.com/api.asmx/login", method: .post, parameters : login)
            
            .responseJSON { response in
            print("RESPONSE")
            let json = response.result.value as! NSDictionary
            self.token = json["token"]! as! String
            print(self.token)
        }
    }
    
    func requestTeamList(){
        
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
    
    func requestTeamMembers(teamName: String){
        
        Alamofire.request("https://r2wmobile4.running2win.com/api.asmx/getTeamMembers", method: .post, parameters : ["token": self.token, "teamToken": self.teamTokens[teamName]!])
            
            .responseJSON { response in
                
               
                let runnerArray = response.result.value as! NSArray
                for i in 0...runnerArray.count-1 {
                    let dict = runnerArray[i] as! NSDictionary
                    let str = (dict["FirstName"] as! String) + " " + (dict["LastName"] as! String)
                    self.teamMembers.append(str)
                   
                }
        }
        
        
        
    }
    

    func getTeamList() -> [String]{
        
        return Array(self.teamTokens.keys)
        
    }
    
    func getTeamMembers() -> [String]{
        
        return self.teamMembers
    }
    
}
