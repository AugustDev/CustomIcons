//
//  ListViewModel.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import Foundation
import Combine

final class ListViewModel: ListModelInjected {
    
    @Published var items = [Icon]()
    @Published var isLoading = false
    
    private var disposables: Set<AnyCancellable> = []
    
    func get() {
        listModel.get()
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .assign(to: \.items, on: self)
            .store(in: &disposables)
    }
}
