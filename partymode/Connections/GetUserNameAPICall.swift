//
//  GetUserNameAPICall.swift
//  partymode
//
//  Created by AppsCreationTech on 1/31/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation
import Alamofire
import KVNProgress
import SwiftyJSON
class GetUserNameAPICall {
    func request(_ sender:UIViewController, contacts: NSArray, completionHandler: @escaping (_ post: NSDictionary) -> Void)
    {
        
//        let loader = HUDLoader()
//        loader.show()
        //=====================parameters, url, headers=====================//
        let url: String = Constants.API_LINK
        let defaults = UserDefaults.standard
        let sid = defaults.string(forKey: "sid")
        let uid = defaults.string(forKey: "uid")
        
        let parameters: Parameters = [
            "contacts": contacts,//["+431111111111"],
            "sid": sid!,
            "uid": uid!,
            "action": "get_usrname"
        ]
        print(parameters)
        //=====================request=====================//
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
            }.responseJSON { response in
                switch response.result {
                case .success(let JSON):
//                    loader.showSuccess()
                    let post = JSON as! NSDictionary
                    print(post)
                    
                    let state = post.object(forKey: "state") as! String
                    if state == "success" {
                        let contacts = post.object(forKey: "contacts") as! NSDictionary
                        print(contacts)
                        completionHandler(contacts)
                    }
                    
                case .failure(let error):
//                    loader.showError()
                    print(error)
                    //NoInternetConnectionAlertClass().showAlert()
                }
        }
        
    }
    
}
