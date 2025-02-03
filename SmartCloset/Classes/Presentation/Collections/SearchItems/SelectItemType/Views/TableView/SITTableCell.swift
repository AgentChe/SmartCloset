//
//  SITTableCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 02.02.2025.
//

import UIKit

final class SITTableCell: UITableViewCell {
    lazy var label = makeLabel()
    lazy var checkedView = makeCheckedView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SITTableCell {
    func setup(element: SITTableElement) {
        label.attributedText = element.itemType.attributed(with: attrs)
        
        let iconName = element.marked ? "SelectItemType.Check.S" : "SelectItemType.Check.D"
        checkedView.image = UIImage(named: iconName)
    }
}

// MARK: Private
private extension SITTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SITTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13.scale)
        ])
        
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 18.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 18.scale),
            checkedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            checkedView.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SITTableCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
