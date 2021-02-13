//
//  ListViewModel.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import Foundation
import Combine

final class ListViewModel: ListModelInjected {
    
    @Published var items = [ListViewItem]()
    @Published var refreshItems = [IndexPath]()
    
    private var originalItems = [ListViewItem]() {
        didSet {
            items = originalItems
        }
    }
    private let pendingOperations = PendingOperation()
    private var disposables: Set<AnyCancellable> = []
    
    func get() {
        listModel.get()
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .map(transform)
            .assign(to: \.originalItems, on: self)
            .store(in: &disposables)
    }
}

// MARK: - ImageLoader
extension ListViewModel {
    func suspendAllOperations() {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells(_ paths: [IndexPath]) {
        
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
    
    func startOperations(for rocketViewItem: ImageItem, at indexPath: IndexPath) {
        switch (rocketViewItem.state) {
        case .new: startDownload(for: rocketViewItem, at: indexPath)
        case .downloaded: print("downloaded")
        default: print("do nothing")
        }
    }
    
    private func startDownload(for rocketViewItem: ImageItem, at indexPath: IndexPath) {
        
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
            return
        }
        
        let downloader = ImageDownloader(rocketViewItem)
        
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

// MARK: - Helpers
private extension ListViewModel {
    func transform(_ items: [Icon]) -> [ListViewItem] {
        items.map { item in
            ListViewItem(item)
        }
    }
}

// MARK: - Search
extension ListViewModel {
    func search(_ query: String) {
        if query != "" {
            items = originalItems.filter { $0.title.contains(query) }
        } else {
            items = originalItems
        }
    }
}
