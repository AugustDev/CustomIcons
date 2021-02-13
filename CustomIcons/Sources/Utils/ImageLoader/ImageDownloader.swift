//
//  ImageDownloader.swift
//  CustomIcons
//
//  Created by emile on 13/02/2021.
//

import UIKit

final class PendingOperation {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

enum ImageState {
    case new, downloaded, failed
}

protocol ImageItem: class {
    var image: String { get }
    var state: ImageState { get set }
    var uiImage: UIImage { get set }
}

final class ImageDownloader: Operation {
    
    let item: ImageItem
    
    init(_ item: ImageItem) {
        self.item = item
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        guard let url = URL(string: item.image) else {
            return
        }
        
        guard let imageData = try? Data(contentsOf: url) else { return }
        
        if isCancelled {
            return
        }
        
        if !imageData.isEmpty {
            item.uiImage = UIImage(data: imageData) ?? UIImage()
            item.state = .downloaded
        } else {
            item.state = .failed
            item.uiImage = UIImage(named: "Failed") ?? UIImage()
        }
    }
}
