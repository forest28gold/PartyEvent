//
//  DKAssetGroup.swift
//  DKImagePickerControllerDemo
//
//  Created by AppsCreationTech on 15/12/13.
//  Copyright © 2015 AppsCreationTech. All rights reserved.
//

import Photos

// Group Model
public class DKAssetGroup : NSObject {
	public var groupId: String!
	public var groupName: String!
	public var totalCount: Int!
	
	public var originalCollection: PHAssetCollection!
	public var fetchResult: PHFetchResult<PHAsset>!
}
