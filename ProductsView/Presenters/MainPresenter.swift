//
//  MainPresenter.swift
//  ProductsView
//
//  Created by mac on 8/19/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

protocol MainPresenterDelegate: NSObjectProtocol {
    func mainPresenter(_ mainPresenter: MainPresenter, reloaded range: Range<Int>)
    func mainPresenter(_ mainPresenter: MainPresenter, updated ids: [Int])
    func mainPresenterGetModelLabel(_ mainPresenter: MainPresenter) -> UILabel?
}

class MainPresenter: NSObject {
    weak var delegate: MainPresenterDelegate?
    
    /// A UILabel to use to measure the description
    var reusableLabel: UILabel? {
        return delegate?.mainPresenterGetModelLabel(self)
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(forName: ProductInteractor.pageLoadedNotification,
                                               object: nil,
                                               queue: OperationQueue.current,
                                               using: { n in self.onReload(n as NSNotification) })
        

        NotificationCenter.default.addObserver(forName: ProductInteractor.dataUpdatedFromDatabase,
                                               object: nil,
                                               queue: OperationQueue.current,
                                               using: { n in self.onUpdate(n as NSNotification) })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var count: Int { return ProductInteractor.shared.count }
    
    func imageData(for index: Int) -> ImageEntity? {
        return productData(for: index)?.image as? ImageEntity
    }
    
    func productData(for index: Int) -> ProductEntity? {
        return ProductInteractor.shared[index]
    }
    
    private func useTheLabelToMeasureTextHeight(for text: String, in size: CGSize) -> CGFloat {
        reusableLabel?.text = text
        return reusableLabel?.sizeThatFits(size).height ?? CGFloat(0)
    }
    
    /// Calculates rects according to bounds, so that we ensure 4 and part of the fifth is displayed
    ///
    /// - Parameter bounds: The bounds to put the rects in
    /// - Returns: The rects to be presented
    func calculateRects(in bounds: CGRect) -> [CGRect] {
        var lastOne = CGFloat(0)
        var ret: [CGRect] = []
        for i in 0..<count {
            if let img = imageData(for: i) {
                let ratio = bounds.width / CGFloat(img.width)
                var height = CGFloat(img.height) * ratio
                height += useTheLabelToMeasureTextHeight(for: productData(for: i)?.description ?? "",
                                                         in: bounds.size)
                height += useTheLabelToMeasureTextHeight(for: "On my list",
                                                         in: bounds.size)
                height += 16
                ret.append(CGRect(x: 0, y: lastOne, width: bounds.width, height: height)
                    .insetBy(dx: 16, dy: 16))
                lastOne += height
            }
        }
        // This is for the final ActivityViewIndicator that indicates loading next page
        ret.append(CGRect(x: 0, y: lastOne, width: bounds.width, height: 128))
        return ret
    }
    
    func getNextPage() {
        ProductInteractor.shared.readNewPage()
    }
    
    func onReload(_ notification: NSNotification) {
        if let page = notification.object as? Range<Int> {
            delegate?.mainPresenter(self, reloaded: page)
        }
    }
    
    func onUpdate(_ notification: NSNotification) {
        if let ids = notification.object as? [Int] {
            delegate?.mainPresenter(self, updated: ids)
        }
    }

}
