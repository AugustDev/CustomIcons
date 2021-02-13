//
//  ReusableCell.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import Foundation

public protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

public extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
