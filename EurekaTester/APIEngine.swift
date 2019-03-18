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
    
    
    func request(){
//        Alamofire.request("https://r2wmobile4.running2win.com/api.asmx?op=login", method: .post, parameters: ["vendorId": "d2e09e0c-a214-4079-b0f5-4cc5aeb19a61"], encoding: .JSON)
        
        Alamofire.request("https://r2wmobile4.running2win.com/api.asmx/login", method: .post, parameters : login)
            
            .responseJSON { response in
            print("RESPONSE")
            let json = response.result.value as! NSDictionary
            print(json["token"])
        }
        
        
        Alamofire.request("https://r2wmobile4.running2win.com/api.asmx/getTeamList", method: .post, parameters : ["token": "61b975d5566c47e29ee1c18f3ef9fc77a17c77e3ea7849a99552ca8aa43093de96772f9c6b154d7d822a16bd13a21f5452d5512d238b4f388bb37d05d2e133a8a1bc8da2c99a41a09170808e5e8b025be7fbe7995e074b798aa7475007b18512a5daecc28ade4230bcde7af8c057636f44458a8b627f4d8baacd61b68307cadf"])
            
            .responseJSON { response in
                print("TEAM LISTS")
                print(response.result.value)
        }
        
        
        
        
    }
}
