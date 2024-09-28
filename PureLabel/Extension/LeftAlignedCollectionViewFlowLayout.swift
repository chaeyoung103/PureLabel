//
//  LeftAlignedCollectionViewFlowLayout.swift
//  PureLabel
//
//  Created by 송채영 on 9/28/24.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        
        let leftPadding: CGFloat = sectionInset.left
        var leftMargin: CGFloat = leftPadding
        var maxY: CGFloat = -1.0
        
        attributes.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else { return }
            
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = leftPadding
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}
