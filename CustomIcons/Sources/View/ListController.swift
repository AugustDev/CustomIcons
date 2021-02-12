//
//  ListController.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit
import Combine

final class ListController: UITableViewController, ListViewModelInjected {

    private var isLoading = false
    private var items = [Icon]() {
        didSet {
            tableView.reloadData()
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
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.allowsSelection = false
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
    }
    
    private func update() {}
}

// MARK: - UITableViewDataSource
extension ListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }

        cell.configure(items[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
