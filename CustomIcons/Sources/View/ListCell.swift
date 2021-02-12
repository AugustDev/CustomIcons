//
//  ListCell.swift
//  CustomIcons
//
//  Created by emile on 12/02/2021.
//

import UIKit

final class ListCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension ListCell {
    private func configure() {
        textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        detailTextLabel?.textColor = .gray
        
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1
        
//        insertSubview(.background(), at: 0)
    }
}


// MARK: - ConfigurableCell
extension ListCell: ConfigurableCell {
    func configure(_ item: Icon) {
        textLabel?.text = item.title
        detailTextLabel?.text = item.subtitle
    }
}

// MARK: - ReusableCell
extension ListCell: ReusableCell {}

// MARK: - UIView
private extension UIView {
    static func background() -> UIView {
        let view = UIView(frame: CGRect(x: 20, y: 10, width: 100, height: 90))
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        return view
    }
}
