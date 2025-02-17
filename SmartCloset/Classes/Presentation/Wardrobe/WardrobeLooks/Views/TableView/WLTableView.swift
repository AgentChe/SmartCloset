//
//  WLTableView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 17.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class WLTableView: UITableView {
    private lazy var elements = [WLTableElement]()
    
    private let didTapSeeMoreTrigger = PublishRelay<WLTableElement.Block>()
    private let didSelectLookTrigger = PublishRelay<Look>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WLTableView {
    func setup(elements: [WLTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapSeeMore: Signal<WLTableElement.Block> {
        didTapSeeMoreTrigger.asSignal()
    }
    
    var didSelectLook: Signal<Look> {
        didSelectLookTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension WLTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withIdentifier: String(describing: WLTableCell.self), for: indexPath) as! WLTableCell
        cell.setup(element: element)
        cell.didTapSeeMore = { [weak self] in
            self?.didTapSeeMoreTrigger.accept(element.block)
        }
        cell.didSelectLook = { [weak self] look in
            self?.didSelectLookTrigger.accept(look)
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension WLTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension WLTableView {
    func initialize() {
        register(WLTableCell.self, forCellReuseIdentifier: String(describing: WLTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
