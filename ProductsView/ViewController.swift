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
        
        super.viewDidLoad()
        mainDataSource = MainCollectionViewDataSource(parent: self)
        mainCollectionView.delegate = mainDataSource!
        mainCollectionView.dataSource = mainDataSource!
        upperEightCollectionView.delegate = self
        upperEightPresenter.delegate = self
        upperEightPresenter.reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Collection view Datasource
    
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
    
    // MARK: - Collection view Delegate

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // All are selectable here
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "productDetails") as? DetailViewController
        viewController?.product =
            upperEightPresenter.object(for: indexPath.row)
        self.show(viewController!, sender: self)
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

