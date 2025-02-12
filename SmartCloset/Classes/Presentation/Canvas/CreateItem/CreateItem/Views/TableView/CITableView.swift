//
//  CITableView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CITableView: UITableView {
    private lazy var elements = [CITableElement]()
    
    private lazy var didInputNameTrigger = PublishRelay<String?>()
    private lazy var didTapCategoryTrigger = PublishRelay<Void>()
    private lazy var didTapTypeTrigger = PublishRelay<Void>()
    private lazy var didTapColorTrigger = PublishRelay<Void>()
    private lazy var didTapMaterialTrigger = PublishRelay<Void>()
    private lazy var didInputCommentTrigger = PublishRelay<String?>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CITableView {
    func setup(elements: [CITableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didInputName: Signal<String?> {
        didInputNameTrigger.asSignal()
    }
    
    var didTapCategory: Signal<Void> {
        didTapCategoryTrigger.asSignal()
    }
    
    var didTapType: Signal<Void> {
        didTapTypeTrigger.asSignal()
    }
    
    var didTapColor: Signal<Void> {
        didTapColorTrigger.asSignal()
    }
    
    var didTapMaterial: Signal<Void> {
        didTapMaterialTrigger.asSignal()
    }
    
    var didInputComment: Signal<String?> {
        didInputCommentTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension CITableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .image(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CITableImageCell.self), for: indexPath) as! CITableImageCell
            cell.setup(element: element)
            return cell
        case .name:
            let cell = dequeueReusableCell(withIdentifier: String(describing: CITableNameCell.self), for: indexPath) as! CITableNameCell
            cell.didChangeName = { [weak self] text in
                self?.didInputNameTrigger.accept(text)
            }
            return cell
        case .category(let category):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CITableFieldCell.self), for: indexPath) as! CITableFieldCell
            cell.setup(category: category)
            return cell
        case .type(let type):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CITableFieldCell.self), for: indexPath) as! CITableFieldCell
            cell.setup(type: type)
            return cell
        case .color(let color):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CITableColorCell.self), for: indexPath) as! CITableColorCell
            cell.setup(color: color)
            return cell
        case .material(let material):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CITableFieldCell.self), for: indexPath) as! CITableFieldCell
            cell.setup(material: material)
            return cell
        case .comments:
            let cell = dequeueReusableCell(withIdentifier: String(describing: CITableCommentsCell.self), for: indexPath) as! CITableCommentsCell
            cell.didChangeText = { [weak self] text in
                self?.didInputCommentTrigger.accept(text)
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension CITableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .image:
            return 280.scale
        default:
            return 92.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .category:
            didTapCategoryTrigger.accept(Void())
        case .type:
            didTapTypeTrigger.accept(Void())
        case .color:
            didTapColorTrigger.accept(Void())
        case .material:
            didTapMaterialTrigger.accept(Void())
        default:
            return
        }
    }
}

// MARK: Private
private extension CITableView {
    func initialize() {
        register(CITableImageCell.self, forCellReuseIdentifier: String(describing: CITableImageCell.self))
        register(CITableNameCell.self, forCellReuseIdentifier: String(describing: CITableNameCell.self))
        register(CITableFieldCell.self, forCellReuseIdentifier: String(describing: CITableFieldCell.self))
        register(CITableColorCell.self, forCellReuseIdentifier: String(describing: CITableColorCell.self))
        register(CITableCommentsCell.self, forCellReuseIdentifier: String(describing: CITableCommentsCell.self))
        
        dataSource = self
        delegate = self
    }
}
