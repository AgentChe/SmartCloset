//
//  OTableView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 28.01.2025.
//

import UIKit

final class OTableView: UITableView {
    enum SelectRule {
        case single, multi
    }
    
    var didChangeSelected: (() -> Void)?
    
    lazy var elements = [OTableElement]()
    
    private let selectRule: SelectRule
    
    init(selectRule: SelectRule) {
        self.selectRule = selectRule
        
        super.init(frame: .zero, style: .plain)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OTableView {
    func setup(elements: [OTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension OTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        
        switch element.entity {
        case .color(let color):
            let cell = dequeueReusableCell(withIdentifier: String(describing: OTableColorCell.self), for: indexPath) as! OTableColorCell
            cell.setup(color: color, marked: element.marked)
            return cell
        case .occasion(let occasion):
            let cell = dequeueReusableCell(withIdentifier: String(describing: OTableTextCheckCell.self), for: indexPath) as! OTableTextCheckCell
            let text = Occasion.DefaultLocalized(occasion: occasion).name
            cell.setup(text: text, marked: element.marked)
            return cell
        case .season(let season):
            let cell = dequeueReusableCell(withIdentifier: String(describing: OTableTextCheckCell.self), for: indexPath) as! OTableTextCheckCell
            let text = Season.DefaultLocalized(season: season).name
            cell.setup(text: text, marked: element.marked)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension OTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectRule {
        case .multi:
            elements[indexPath.row].marked.toggle()
        case .single:
            elements.enumerated().forEach { $1.marked = $0 == indexPath.row }
        }
        
        reloadData()
        
        didChangeSelected?()
    }
}

// MARK: Private
private extension OTableView {
    func initialize() {
        register(OTableColorCell.self, forCellReuseIdentifier: String(describing: OTableColorCell.self))
        register(OTableTextCheckCell.self, forCellReuseIdentifier: String(describing: OTableTextCheckCell.self))
        
        dataSource = self
        delegate = self
    }
}
