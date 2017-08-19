//
//  AutoLayoutImageView.swift
//  ProductsView
//
//  Created by mac on 8/19/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

class AutoLayoutImageView: UIImageView {

    var aspectRatioConstraint: NSLayoutConstraint?
    
    /// Initializes aspect ratio constraint from the image
    func initializeAspectRatioConstraints() {
        // Deactivate the previous one, if any
        aspectRatioConstraint?.isActive = false
        
        // Initialize a new one, then activate it
        aspectRatioConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal,
                                                   toItem: self, attribute: .width,
                                                   multiplier: CGFloat(aspectRatio), constant: 0)
        aspectRatioConstraint?.isActive = true
    }
    
    func initializeConstraints() {
        initializeAspectRatioConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeConstraints()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        initializeConstraints()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        initializeConstraints()
    }
    
    /// Height over width ratio
    var aspectRatio: CGFloat = 1 {
        didSet {
            initializeAspectRatioConstraints()
        }
    }

}
