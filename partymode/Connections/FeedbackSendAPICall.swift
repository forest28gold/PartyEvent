//
//  FeedbackSendAPICall.swift
//  partymode
//
//  Created by AppsCreationTech on 1/21/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation
import Alamofire
class FeedbackSendAPICall {
    func request(_ sender:UIViewController, feedbackString: String, stars: Int, completionHandler: @escaping (_ post: NSDictionary) -> Void)
    {
        
        let loader = HUDLoader()
        //loader.show()
        //=====================parameters, url, headers=====================//
        let url: String = Constants.API_LINK
        let defaults = UserDefaults.standard
        let sid = defaults.string(forKey: "sid")
        let uid = defaults.string(forKey: "uid")
        
        let parameters: Parameters = [
            "feedback": feedbackString,//"FeedbackText",
            "stars": stars,//5
            "sid": sid!,
            "uid": uid!,
            "action": "feedback"
        ]
        print(parameters)
        //=====================request=====================//
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
            }.responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    //loader.showSuccess()
                    let post = JSON as! NSDictionary
                    print(post)
                    let state = post.object(forKey: "state") as! String
                    if state == "success" {
                        completionHandler(post)
                    }
                    else{
                        _ = sender.navigationController?.popToRootViewController(animated: true)
                    }
                    
                case .failure(let error):
                    loader.showError()
                    print(error)
                    //NoInternetConnectionAlertClass().showAlert()
                }
        }
        
    }   
}
