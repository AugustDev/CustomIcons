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
    
    private var items = [ListViewItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var refreshItems = [IndexPath]() {
        didSet {
            tableView.reloadRows(at: refreshItems, with: .fade)
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
        listViewModel.$isLoading
            .receive(on: RunLoop.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &disposables)
        
        listViewModel.$items
            .receive(on: RunLoop.main)
            .assign(to: \.items, on: self)
            .store(in: &disposables)
        
        listViewModel.$refreshItems
            .receive(on: RunLoop.main)
            .assign(to: \.refreshItems, on: self)
            .store(in: &disposables)
    }
}

// MARK: - UI
extension ListController {
    private func setup() {
        title = "Custom Icons"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.allowsSelection = false
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

        let item = items[indexPath.row]
        
        // Populate Cell
        cell.configure(item)
        
        // Load Images
        if case ImageState.new = item.state {
            if !tableView.isDragging && !tableView.isDecelerating {
                listViewModel.startOperations(for: item, at: indexPath)
            }
        }
        
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension ListController {
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        listViewModel.suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenCells()
            listViewModel.resumeAllOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenCells()
        listViewModel.resumeAllOperations()
    }
}

// MARK: - Image Download Methods
extension ListController {
    func loadImagesForOnscreenCells() {
        if let paths = tableView.indexPathsForVisibleRows {
            listViewModel.loadImagesForOnscreenCells(paths)
        }
    }
}
