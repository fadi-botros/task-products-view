//
//  MainCollectionViewCell.swift
//  ProductsView
//
//  Created by mac on 8/19/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: AutoLayoutImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    var observeOnSaved = 0
    
    var product: ProductEntity? {
        willSet {
            product?.removeObserver(self, forKeyPath: #keyPath(ProductEntity.saved))
        }
        didSet {
            product?.addObserver(self, forKeyPath: #keyPath(ProductEntity.saved), options: .initial, context: &observeOnSaved)
            updateView()
        }
    }
    
    deinit {
        product?.removeObserver(self, forKeyPath: #keyPath(ProductEntity.saved))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateView()
    }
    
    func updateView() {
        let imgData = product?.image as? ImageEntity
        imageView.aspectRatio = CGFloat(imgData?.height ?? 1) / CGFloat(imgData?.width ?? 1)
        imageView.imageURL = imgData?.url
        descriptionLabel.text = product?.productDescription ?? ""
        priceLabel.text = "\(product?.price ?? 0)"
        updateSaved()
    }
    
    func updateSaved() {
        if product?.saved == true {
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func onSave(_ sender: Any) {
        ProductInteractor.shared.save(of: product!.id)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &observeOnSaved {
            if keyPath == #keyPath(ProductEntity.saved) {
                updateSaved()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}
