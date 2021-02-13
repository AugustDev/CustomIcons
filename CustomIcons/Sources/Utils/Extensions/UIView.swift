//
//  UIView.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit

// MARK: - AutoLayout Helper
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0, bottom: NSLayoutYAxisAnchor? = nil, paddingBottom: CGFloat = 0, left: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0, right: NSLayoutXAxisAnchor? = nil, paddingRight: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}

// MARK: - UIActivityIndicatorView
extension UIView {
    static func indicator(style: UIActivityIndicatorView.Style = .medium) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.startAnimating()
        return indicator
    }
}
