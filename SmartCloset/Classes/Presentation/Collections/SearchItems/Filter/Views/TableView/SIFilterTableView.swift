//
//  SIFilterTableView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SIFilterTableView: UITableView {
    private lazy var elements = [SIFilterTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<SIFilterTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SIFilterTableView {
    func setup(elements: [SIFilterTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<SIFilterTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SIFilterTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .category(let category):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SIFilterTableCell.self), for: indexPath) as! SIFilterTableCell
            cell.setup(category: category)
            return cell
        case .type(let type):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SIFilterTableCell.self), for: indexPath) as! SIFilterTableCell
            cell.setup(type: type)
            return cell
        case .color(let color):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SIFilterTableColorCell.self), for: indexPath) as! SIFilterTableColorCell
            cell.setup(color: color)
            return cell
        case .material(let material):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SIFilterTableCell.self), for: indexPath) as! SIFilterTableCell
            cell.setup(material: material)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SIFilterTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        92.scale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SIFilterTableView {
    func initialize() {
        register(SIFilterTableCell.self, forCellReuseIdentifier: String(describing: SIFilterTableCell.self))
        register(SIFilterTableColorCell.self, forCellReuseIdentifier: String(describing: SIFilterTableColorCell.self))
        
        dataSource = self
        delegate = self
    }
}
