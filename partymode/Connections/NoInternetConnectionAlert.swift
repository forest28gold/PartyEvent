//
//  NoInternetConnectionAlert.swift
//  partymode
//
//  Created by AppsCreationTech on 1/21/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation
class NoInternetConnectionAlertClass {
    func showAlert(){
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let alert = UIAlertController(title: NSLocalizedString("alert_no_internet_connection_title",comment:""), message: NSLocalizedString("alert_no_internet_connection_text",comment:""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            topController.present(alert, animated: true, completion: nil)
        }
    }
}
