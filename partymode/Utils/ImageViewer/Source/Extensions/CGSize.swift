//
//  CGSize.swift
//  ImageViewer
//
//  Created by AppsCreationTech on 04/12/2015.
//  Copyright © 2015 AppsCreationTech. All rights reserved.
//

import CoreGraphics

extension CGSize {
    
    func inverted() -> CGSize {
        
        return CGSize(width: self.height, height: self.width)
    }
}
