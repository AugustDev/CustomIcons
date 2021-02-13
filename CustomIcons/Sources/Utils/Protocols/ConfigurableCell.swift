//
//  ConfigurableCell.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import Foundation

public protocol ConfigurableCell {
    associatedtype T
    func configure(_ item: T)
}
