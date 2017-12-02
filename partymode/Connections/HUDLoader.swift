//
//  HUDLoader.swift
//  partymode
//
//  Created by AppsCreationTech on 1/30/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import KVNProgress

class HUDLoader: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func show(){
        KVNProgress.show()
    }
    
    func showWithStatus(_ status:String){
        KVNProgress.show(withStatus: status)
    }
    
    func showSuccess(){
        KVNProgress.showSuccess(withStatus: "")
    }    
    
    func showError(){
        KVNProgress.showError(withStatus: "Connection Failed")
    }

}
