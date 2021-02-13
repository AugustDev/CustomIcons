//
//  ListViewLoader.swift
//  CustomIcons
//
//  Created by emile on 13/02/2021.
//

import Foundation

final class ListViewLoader {
    
    @Published var refreshItems = [IndexPath]()
    
    private let pendingOperations = PendingOperation()
    
    func suspendAllOperations() {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells(_ paths: [IndexPath], items: [ImageItem]) {
        
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
        
        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(paths)
        toBeCancelled.subtract(visiblePaths)
        
        var toBeStarted = visiblePaths
        toBeStarted.subtract(allPendingOperations)
        
        for indexPath in toBeCancelled {
            if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                pendingDownload.cancel()
            }
            pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        }
        
        for indexPath in toBeStarted {
            let itemToProcess = items[indexPath.row]
            startOperations(for: itemToProcess, at: indexPath)
        }
    }
    
    func startOperations(for listViewItem: ImageItem, at indexPath: IndexPath) {
        switch (listViewItem.state) {
        case .new: startDownload(for: listViewItem, at: indexPath)
        case .downloaded: print("downloaded")
        default: print("do nothing")
        }
    }
    
    private func startDownload(for listViewItem: ImageItem, at indexPath: IndexPath) {
        
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
            return
        }
        
        let downloader = ImageDownloader(listViewItem)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            self.refreshItems = [indexPath]
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}
