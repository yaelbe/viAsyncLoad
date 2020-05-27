//
//  PhotoCell.swift
//  ViAsyncLoad
//
//  Created by Yael Bilu Eran on 27/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
  
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  @IBOutlet private weak var imageView: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    imageView.backgroundColor = UIColor.gray
    imageView.layoutMargins = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 10.0
  }
  
  override func prepareForReuse() {
    imageView.image = nil
    indicator.isHidden = false
  }
  var photo: UIImage? {
    didSet {
      if let photo = photo {
        imageView.image = photo
        indicator.isHidden = true
      }
    }
  }
}
