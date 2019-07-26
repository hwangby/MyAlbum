//
//  PhotoCollectionViewCell.swift
//  MyAlbum
//
//  Created by 황병윤 on 21/05/2019.
//  Copyright © 2019 HBY. All rights reserved.
//

import UIKit
import Photos

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    var photoFetchResult: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>.init()
}
