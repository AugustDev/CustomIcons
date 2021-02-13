//
//  ListViewItem.swift
//  CustomIcons
//
//  Created by emile on 13/02/2021.
//

import UIKit

final class ListViewItem: DataItem, ImageItem {

    let title: String
    let subtitle: String
    let image: String
    
    var state = ImageState.new
    var uiImage = UIImage()
    
    init(_ item: DataItem) {
        title = item.title
        subtitle = item.subtitle
        image = item.image
    }
}
