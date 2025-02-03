//
//  SICTableView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 02.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SICTableView: UITableView {
    private lazy var elements = [ItemCategory]()
    
    private lazy var didSelectTrigger = PublishRelay<ItemCategory>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SICTableView {
    func setup(elements: [ItemCategory]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<ItemCategory> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SICTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: SICTableCell.self), for: indexPath) as! SICTableCell
        cell.setup(category: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension SICTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64.scale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SICTableView {
    func initialize() {
        register(SICTableCell.self, forCellReuseIdentifier: String(describing: SICTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
