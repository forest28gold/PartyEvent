//
//  Section.swift
//  sections
//
//  Created by AppsCreationTech on 9/11/15.
//  Copyright © 2015 AppsCreationTech. All rights reserved.
//

import Foundation

struct Sections {
    
    var headings : String
    //var items : [String]
    var partypeoples: [PartyPeopleCellData]
    var partycrowds: [PartyCrowdCellData]
   
    init(title: String, objects : [PartyPeopleCellData]) {
    
        headings = title
        partypeoples = objects
        partycrowds = []
        
    }
    
    init(title: String, objects : [PartyCrowdCellData]) {
        
        headings = title
        partypeoples = []
        partycrowds = objects
        
    }
}
