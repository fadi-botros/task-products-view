//
//  DetailViewController.swift
//  ProductsView
//
//  Created by mac on 8/20/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {
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
    
    func updateView() {
        guard isViewLoaded else { return }
        let imgData = product?.image as? ImageEntity
        imageView.aspectRatio = CGFloat(imgData?.height ?? 1) / CGFloat(imgData?.width ?? 1)
        imageView.imageURL = imgData?.url
        descriptionLabel.text = product?.productDescription ?? ""
        priceLabel.text = "\(product?.price ?? 0)"
        updateSaved()
    }
    
    func updateSaved() {
        guard isViewLoaded else { return }
        if product?.saved == true {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func save(_ sender: Any) {
        ProductInteractor.shared.save(of: product!.id)
    }
    
    @IBAction func tweetButton(_ sender: Any) {
        if !SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let alert = UIAlertController(title: "Error", message: "Twitter is not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if let viewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
                viewController.setInitialText(product?.productDescription)
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
}
