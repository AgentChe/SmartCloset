//
//  ItemTableView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

import UIKit

final class ItemTableView: UITableView {
    private lazy var elements = [ItemTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ItemTableView {
    func setup(elements: [ItemTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ItemTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .image(let url):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ItemTableImageCell.self), for: indexPath) as! ItemTableImageCell
            cell.setup(url: url)
            return cell
        case .textField(let title, let value):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ItemTableTextFieldCell.self), for: indexPath) as! ItemTableTextFieldCell
            cell.setup(title: title, value: value)
            return cell
        case .color(let color):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ItemTableColorCell.self), for: indexPath) as! ItemTableColorCell
            cell.setup(color: color)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ItemTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension ItemTableView {
    func initialize() {
        register(ItemTableTextFieldCell.self, forCellReuseIdentifier: String(describing: ItemTableTextFieldCell.self))
        register(ItemTableColorCell.self, forCellReuseIdentifier: String(describing: ItemTableColorCell.self))
        register(ItemTableImageCell.self, forCellReuseIdentifier: String(describing: ItemTableImageCell.self))
        
        dataSource = self
        delegate = self
    }
}
