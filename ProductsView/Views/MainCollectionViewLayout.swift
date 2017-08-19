//
//  MainCollectionViewLayout.swift
//  ProductsView
//
//  Created by mac on 8/19/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

class MainCollectionViewLayout: UICollectionViewLayout {
    
    var rects: [CGRect] = []
    
    override var collectionViewContentSize: CGSize {
        return CGSize.init(width: collectionView!.bounds.width, height: rects.last?.maxY ?? 128)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let ret = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        ret.frame = rects[indexPath.row]
        return ret
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var before = true
        var ret: [UICollectionViewLayoutAttributes] = []
        for (i, r) in rects.enumerated() {
            if r.intersects(rect) {
                if before { before = false }
                ret.append(layoutAttributesForItem(at: IndexPath(row: i, section: 0))!)
            } else {
                if !before { break }
            }
        }
        return ret
    }

}
