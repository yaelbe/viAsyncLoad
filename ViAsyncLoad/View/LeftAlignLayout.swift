//
//  LeftAlignLayout.swift
//  ViAsyncLoad
//
//  Created by Yael Bilu Eran on 27/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import UIKit

class LeftAlignFlowLayout: UICollectionViewFlowLayout {
    required init(minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        super.init()
        
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        if #available(iOS 11.0, *) {
            sectionInsetReference = .fromSafeArea
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
       let attr = super.layoutAttributesForElements(in: rect)
        var attributes = [UICollectionViewLayoutAttributes]()
        for itemAttributes in attr! {
            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
            attributes.append(itemAttributesCopy)
        }
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}

