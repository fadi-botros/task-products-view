//
//  ViewController.swift
//  ProductsView
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UpperEightPresenterDelegate {
    
    var upperEightPresenter: UpperEightPresenter = UpperEightPresenter()
    
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    var sizes: [CGSize] = []
    
    var mainDataSource: MainCollectionViewDataSource?

    @IBOutlet weak var upperEightCollectionView: UICollectionView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        print(String.init(format: "%lu", Int64(1234)))
        
        super.viewDidLoad()
        mainDataSource = MainCollectionViewDataSource(parent: self)
        mainCollectionView.dataSource = mainDataSource!
        upperEightCollectionView.delegate = self
        upperEightPresenter.delegate = self
        upperEightPresenter.reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upperEightPresenter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        (cell.viewWithTag(1) as? UIImageView)?.imageURL =
            upperEightPresenter.imageURL(for: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizes[indexPath.row]
    }

    func upperEightPresenterReload(_ upperEightPresenter: UpperEightPresenter) {
        sizes = upperEightPresenter.calculateRects(in: upperEightCollectionView.bounds)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.collectionHeight.constant = self.sizes[0].height + 8
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            })
            self.upperEightCollectionView.reloadData()
        }
    }
}

