//
//  ListController.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit
import Combine

final class ListController: UITableViewController, ListViewModelInjected {

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
    
    lazy private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
       return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
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
        
        // SearchField Text Changed
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification,
                                             object: searchController.searchBar.searchTextField)
            .map { ($0.object as? UISearchTextField)?.text ?? "" }
            .delay(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue: { [listViewModel] value in
                listViewModel.search(value)
            })
            .store(in: &disposables)
        
        // SearchField Cancel
        NotificationCenter.default.publisher(for: UISearchTextField.textDidEndEditingNotification,
                                             object: searchController.searchBar.searchTextField)
            .sink(receiveValue: { [listViewModel] value in
                listViewModel.search("")
            })
            .store(in: &disposables)
        
        // Items
        listViewModel.$items
            .receive(on: RunLoop.main)
            .assign(to: \.items, on: self)
            .store(in: &disposables)
        
        // Refresh Items
        listViewModel.$refreshItems
            .receive(on: RunLoop.main)
            .assign(to: \.refreshItems, on: self)
            .store(in: &disposables)
    }
}

// MARK: - UI
extension ListController {
    private func configureView() {
        
        // View
        title = "Custom Icons"
        view.backgroundColor = .white
        
        // NavigationController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController

        // TableView
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
        tableView.backgroundView = .indicator(style: .large)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.allowsSelection = false
    }
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
                listViewModel.listViewLoader.startOperations(for: item, at: indexPath)
            }
        }
        
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension ListController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        listViewModel.listViewLoader.suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenCells()
            listViewModel.listViewLoader.resumeAllOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenCells()
        listViewModel.listViewLoader.resumeAllOperations()
    }
}

// MARK: - Image Download Methods
extension ListController {
    func loadImagesForOnscreenCells() {
        if let paths = tableView.indexPathsForVisibleRows {
            listViewModel.listViewLoader.loadImagesForOnscreenCells(paths, items: items)
        }
    }
}
