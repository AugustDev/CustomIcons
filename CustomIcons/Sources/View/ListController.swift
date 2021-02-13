//
//  ListController.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit
import Combine

final class ListController: UIViewController, ListViewModelInjected {

    private var isLoading = false {
        didSet {
            updateView()
        }
    }
    
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
    
    lazy private var indicator: UIActivityIndicatorView = {
        return .indicator(style: .large)
    }()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.allowsSelection = false
        tableView.dataSource = self
        return tableView
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
    private func configureView() {
        title = "Custom Icons"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(indicator)
        view.addSubview(tableView)
        
        //
        configureLayout()
    }
    
    private func configureLayout() {
        
        indicator.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
        
        tableView.anchor(top: view.topAnchor, paddingTop: 5,
                         bottom: view.bottomAnchor, paddingBottom: 5,
                         left: view.leftAnchor,
                         right: view.rightAnchor)
    }
    
    private func updateView() {
        tableView.isHidden = isLoading
        isLoading ? indicator.startAnimating():indicator.stopAnimating()
    }
}

// MARK: - UITableViewDataSource
extension ListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
extension ListController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        listViewModel.suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenCells()
            listViewModel.resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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

// MARK: - UIView
extension UIView {
    static func indicator(style: UIActivityIndicatorView.Style = .medium) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.startAnimating()
        return indicator
    }
}
