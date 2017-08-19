//
//  MainCollectionViewDataSource.swift
//  ProductsView
//
//  Created by mac on 8/19/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

class MainCollectionViewDataSource: NSObject, UICollectionViewDataSource, MainPresenterDelegate {
    unowned let parent: ViewController
    
    var presenter: MainPresenter
    
    init(parent: ViewController) {
        self.parent = parent
        presenter = MainPresenter()
        super.init()
        presenter.delegate = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row != presenter.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath)
            (cell as? MainCollectionViewCell)?.product = presenter.productData(for: indexPath.row)
            if (presenter.count - indexPath.row) < 3 {
                presenter.getNextPage()
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activity", for: indexPath)
            (cell.viewWithTag(1) as? UIActivityIndicatorView)?.startAnimating()
            return cell
        }
    }
    
    func mainPresenter(_ mainPresenter: MainPresenter, reloaded range: Range<Int>) {
        var indexPaths: [IndexPath] = []
        for i in range.lowerBound..<range.upperBound {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        if let layout = parent.mainCollectionView.collectionViewLayout as? MainCollectionViewLayout {
            layout.rects = presenter.calculateRects(in: parent.mainCollectionView.bounds)
            parent.mainCollectionView.insertItems(at: indexPaths)
            layout.invalidateLayout()
        }
    }
    
    func mainPresenter(_ mainPresenter: MainPresenter, updated ids: [Int]) {
        var indexPaths: [IndexPath] = []
        for i in ids {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        if let layout = parent.mainCollectionView.collectionViewLayout as? MainCollectionViewLayout {
            layout.rects = presenter.calculateRects(in: parent.mainCollectionView.bounds)
            parent.mainCollectionView.reloadItems(at: indexPaths)
            layout.invalidateLayout()
        }
    }
    
    func mainPresenterGetModelLabel(_ mainPresenter: MainPresenter) -> UILabel? {
        return parent.modelLabel
    }
    
    
}
