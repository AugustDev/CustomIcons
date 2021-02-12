//
//  ListController.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit
import Combine

final class ListController: UIViewController, ListViewModelInjected {

    private var isLoading = false
    private var items = [Icon]() {
        didSet {
            print(items)
        }
    }
    
    private var disposables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listViewModel.get()
    }
}

// MARK: - Binding
extension ListController {
    func configureBinding() {
        listViewModel.$items
            .receive(on: RunLoop.main)
            .assign(to: \.items, on: self)
            .store(in: &disposables)
    }
}

// MARK: - UI
extension ListController {
    private func setup() {
        title = "Custom Icons"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func update() {}
}
