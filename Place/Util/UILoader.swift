//
//  UILoader.swift
//  Place
//
//  Created by Pierre Chamorro on 6/16/19.
//  Copyright © 2019 Pierre Chamorro. All rights reserved.
//
import UIKit
import Foundation

class UILoader {
    static let instance = UILoader()
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    public func showOverlay(view: UIView) {
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2-60)
        overlayView.backgroundColor = UIColor.gray
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        activityIndicator.startAnimating()
    }
    func finishOverlay() {
        DispatchQueue.main.async { 
            self.overlayView.removeFromSuperview()
        }
        
    }
}
