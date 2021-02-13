//
//  ListCell.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit

final class ListCell: UITableViewCell {
    
    let indicator = ListCell.indicator()
    
    private let background = ListCell.background()
    private let container = ListCell.container()
    private let iconImageView = ListCell.iconImageView()
    private let titleLabel = ListCell.titleLabel()
    private let subtitleLabel = ListCell.subtitleLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ConfigurableCell
extension ListCell: ConfigurableCell {
    func configure(_ item: ListViewItem) {
        
        // Reset View
        resetView()
        
        // Info
        iconImageView.image = item.uiImage
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        
        // Indicator State
        switch (item.state) {
        case .failed: indicator.stopAnimating()
        case .new: indicator.startAnimating()
        case .downloaded: indicator.stopAnimating()
        }
    }
}

// MARK: - UI
extension ListCell {
    private func setupView() {
        
        //
        selectionStyle = .none
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
        preservesSuperviewLayoutMargins = false
        
        if accessoryView == nil {
            accessoryView = indicator
        }
        
        // Add views
        addSubview(background)
        background.addSubview(container)
        container.addArrangedSubview(iconImageView)
        
        let labelsContainer = ListCell.labelsContainer()
        labelsContainer.addArrangedSubview(titleLabel)
        labelsContainer.addArrangedSubview(subtitleLabel)
        container.addArrangedSubview(labelsContainer)
        
        //
        setupLayout()
    }
    
    private func setupLayout() {
        background.anchor(top: topAnchor, paddingTop: 5,
                          bottom: bottomAnchor, paddingBottom: 5,
                          left: leftAnchor, paddingLeft: 20,
                          right: rightAnchor, paddingRight: 20)
        
        container.anchor(top: background.topAnchor, paddingTop: 15,
                         bottom: background.bottomAnchor, paddingBottom: 15,
                         left: background.leftAnchor, paddingLeft: 10,
                         right: background.rightAnchor, paddingRight: 5)
        
        iconImageView.anchor(width: 45, height: 45)
    }
    
    private func resetView() {
        iconImageView.image = UIImage()
        titleLabel.text = ""
        subtitleLabel.text = ""
    }
}

// MARK: - ReusableCell
extension ListCell: ReusableCell {}

// MARK: - UIView
private extension UIView {    
    static func background() -> UIView {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.20
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }
    
    static func container() -> UIStackView {
        let stack = UIStackView(frame: CGRect.zero)
        stack.spacing = 10
        return stack
    }
    
    static func iconImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }
    
    static func labelsContainer() -> UIStackView {
        let stack = UIStackView(frame: CGRect.zero)
        stack.axis = .vertical
        return stack
    }
    
    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }
    
    static func subtitleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .lightGray
        return label
    }
}
