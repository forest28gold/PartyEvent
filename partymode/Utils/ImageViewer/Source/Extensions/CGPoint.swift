//
//  CGPoint.swift
//  ImageViewer
//
//  Created by AppsCreationTech on 08/12/2015.
//  Copyright © 2015 AppsCreationTech. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    func inverted() -> CGPoint {
        
        return CGPoint(x: self.y, y: self.x)
    }
}
