//
//  ThumbnailsCell.swift
//  ImageViewer
//
//  Created by AppsCreationTech on 07/07/2016.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit

class ThumbnailsCell: UICollectionViewCell {

    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        imageView.frame = bounds
        super.layoutSubviews()
    }
}
