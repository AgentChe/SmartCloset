//
//  ChangeOccasionsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

import UIKit

final class ChangeOccasionsView: ChangeProfileFieldView {
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
        let occasions = tableView
            .elements.filter { $0.marked }
            .compactMap { element -> Occasion? in
                guard case let .occasion(occasion) = element.entity else { return nil }
                return occasion
            }
        return .occasions(occasions)
    }
    
    override func canSave() -> Bool {
        tableView.elements.contains(where: { $0.marked })
    }
}

// MARK: Public
extension ChangeOccasionsView {
    func setup(occasions: [Occasion]?) {
        guard let occasions else { return }
        
        let elements = Occasion.allCases
            .map { occasion -> OTableElement in
                OTableElement(
                    entity: .occasion(occasion),
                    marked: occasions.contains(occasion)
                )
            }
        tableView.setup(elements: elements)
        
        updateSaveEnable()
    }
}

// MARK: Private
private extension ChangeOccasionsView {
    func initialize() {
        backgroundColor = Appearance.mono200
        
        tableView.didChangeSelected = { [weak self] in
            self?.updateSaveEnable()
        }
        
        let elements = Occasion.allCases.map { OTableElement(entity: .occasion($0)) }
        tableView.setup(elements: elements)
        
        updateSaveEnable()
    }
}

// MARK: Make constraints
private extension ChangeOccasionsView {
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
private extension ChangeOccasionsView {
    func makeTableView() -> OTableView {
        let view = OTableView(selectRule: .multi)
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
