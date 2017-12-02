//
//  BackendConnectionErrorAlert.swift
//  partymode
//
//  Created by AppsCreationTech on 1/21/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation
class BackendConnectionErrorAlert {
    func show(){
        let alert = UIAlertView(title: "Partymode", message: NSLocalizedString("alert_connection_error",comment:""), delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
}
