//
//  ImageViewControllerDelegate.swift
//  ImageViewer
//
//  Created by AppsCreationTech on 04/03/2016.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit

protocol ImageViewControllerDelegate: class {
    
    func imageViewController(_ controller: ImageViewController, didSwipeToDismissWithDistanceToEdge distance: CGFloat)
    
    func imageViewControllerDidSingleTap(_ controller: ImageViewController)
    
    func imageViewControllerDidAppear(_ controller: ImageViewController)
}
