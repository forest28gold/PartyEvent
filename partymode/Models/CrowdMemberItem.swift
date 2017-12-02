//
//  CrowdMemberItem.swift
//  partymode
//
//  Created by AppsCreationTech on 3/18/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation
struct CrowdMemberItem {
    
    
    var crowdId : String
    var phoneNumber : String
    var status:Int
    var msg:String
    
    init(crowdId: String, phoneNumber: String, status : Int, msg:String) {
        self.crowdId = crowdId
        self.phoneNumber = phoneNumber
        self.status = status
        self.msg = msg
    }
}
