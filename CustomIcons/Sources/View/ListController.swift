//
//  ListController.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit
import Combine

final class ListController: UIViewController {

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
