//
//  ListViewModel.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import Foundation
import Combine

final class ListViewModel: ListModelInjected, ListViewLoaderInjected {
    
    @Published var items = [ListViewItem]()
    @Published var refreshItems = [IndexPath]()
    
    private var originalItems = [ListViewItem]() {
        didSet {
            items = originalItems
        }
    }
    
    private var disposables: Set<AnyCancellable> = []
    
    init() {
        listViewLoader.$refreshItems
            .assign(to: \.refreshItems, on: self)
            .store(in: &disposables)
    }
    
    func get() {
        listModel.get()
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .map(transform)
            .assign(to: \.originalItems, on: self)
            .store(in: &disposables)
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
