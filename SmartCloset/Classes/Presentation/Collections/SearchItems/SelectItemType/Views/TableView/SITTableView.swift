//
//  SITTableView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 02.02.2025.
//

import UIKit

final class SITTableView: UITableView {
    var didChangedSelected: ((Bool) -> Void)?
    
    private lazy var elements = [SITTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SITTableView {
    func setup(elements: [SITTableElement]) {
        self.elements = elements
        
        reloadData()
        
        notifyAboutChangeSelected()
    }
}

// MARK: UITableViewDataSource
extension SITTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: SITTableCell.self), for: indexPath) as! SITTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension SITTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        elements.enumerated().forEach { index, element in
            element.marked = index == indexPath.row
        }
        
        reloadData()
        
        notifyAboutChangeSelected()
    }
}

// MARK: Private
private extension SITTableView {
    func initialize() {
        register(SITTableCell.self, forCellReuseIdentifier: String(describing: SITTableCell.self))
        
        dataSource = self
        delegate = self
    }
    
    func notifyAboutChangeSelected() {
        didChangedSelected?(elements.contains(where: { $0.marked }))
    }
}
