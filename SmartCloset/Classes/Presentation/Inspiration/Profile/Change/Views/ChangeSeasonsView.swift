//
//  ChangeSeasonsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

import UIKit

final class ChangeSeasonsView: ChangeProfileFieldView {
    lazy var tableView = makeTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeField() -> ChangeProfileFieldView.ChangedField? {
        let selectedElement = tableView
            .elements.first(where: { $0.marked })
        
        let season: Season? = {
            guard let selectedElement, case let .season(season) = selectedElement.entity else { return nil }
            return season
        }()
        
        guard let season else { return nil }
        
        return .season(season)
    }
    
    override func canSave() -> Bool {
        tableView.elements.contains(where: { $0.marked })
    }
}

// MARK: Public
extension ChangeSeasonsView {
    func setup(season: Season?) {
        guard let selected = season else { return }
        
        let elements = Season.allCases
            .map { season -> OTableElement in
                OTableElement(
                    entity: .season(season),
                    marked: selected == season
                )
            }
        tableView.setup(elements: elements)
        
        updateSaveEnable()
    }
}

// MARK: Private
private extension ChangeSeasonsView {
    func initialize() {
        backgroundColor = Appearance.mono200
        
        tableView.didChangeSelected = { [weak self] in
            self?.updateSaveEnable()
        }
        
        let elements = Season.allCases.map { OTableElement(entity: .season($0)) }
        tableView.setup(elements: elements)
        
        updateSaveEnable()
    }
}

// MARK: Make constraints
private extension ChangeSeasonsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -74.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChangeSeasonsView {
    func makeTableView() -> OTableView {
        let view = OTableView(selectRule: .single)
        view.contentInset = UIEdgeInsets(vertical: 30.scale)
        view.setContentOffset(CGPoint(x: 0, y: -30.scale), animated: false)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
