//
//  SCTableView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 03.02.2025.
//

import UIKit

final class SCTableView: UITableView {
    var didChangedSelected: ((Bool) -> Void)?
    
    private lazy var elements = [SCTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SCTableView {
    func setup(elements: [SCTableElement]) {
        self.elements = elements
        
        reloadData()
        
        notifyAboutChangeSelected()
    }
}

// MARK: UITableViewDataSource
extension SCTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: SCTableCell.self), for: indexPath) as! SCTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension SCTableView: UITableViewDelegate {
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
private extension SCTableView {
    func initialize() {
        register(SCTableCell.self, forCellReuseIdentifier: String(describing: SCTableCell.self))
        
        dataSource = self
        delegate = self
    }
    
    func notifyAboutChangeSelected() {
        didChangedSelected?(elements.contains(where: { $0.marked }))
    }
}
