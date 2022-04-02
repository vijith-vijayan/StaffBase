//
//  ProgressHUD.swift
//  StaffBase
//
//  Created by Vijith TV on 06/03/22.
//

import UIKit

protocol Loadable {
    func showHUD()
    func dismissHUD()
}

final class ProgressHUD: UIView {
    
    //MARK: - PROPERTIES
    static let loadingViewTag = 1234
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    //MARK: - LAYOUT SUBVIEWS
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.cornerRadius = 5
        
        if activityIndicatorView.superview == nil {
            addSubview(activityIndicatorView)
            activityIndicatorView.color = .white
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            activityIndicatorView.startAnimating()
        }
    }
    
    //MARK: - ANIMATE
    public func animate() {
        activityIndicatorView.startAnimating()
    }
}

/// Default implementation for UIViewController
extension Loadable where Self: UIViewController {
    
    //MARK: - SHOW LOADER

    func showHUD() {
        DispatchQueue.main.async {
            let loadingView = ProgressHUD()
            self.view.addSubview(loadingView)
            
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            loadingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            loadingView.animate()
            
            loadingView.tag = ProgressHUD.loadingViewTag
        }
    }
    
    //MARK: - HIDE

    func dismissHUD() {
        DispatchQueue.main.async {
            self.view.subviews.forEach { subview in
                if subview.tag == ProgressHUD.loadingViewTag {
                    subview.removeFromSuperview()
                }
            }
        }
    }
}
