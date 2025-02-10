//
//  CCSLAttachmentItemButton.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 09.02.2025.
//

import UIKit

final class CCSLAttachmentItemButton: UIButton {
    enum Attachment {
        case `internal`, custom
    }
    
    lazy var marked: Bool = false {
        didSet {
            update()
        }
    }
    
    lazy var label = makeLabel()
    lazy var countLabel = makeCountLabel()
    lazy var separator = makeSeparator()
    
    let attachment: Attachment
    
    private lazy var countAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SofiaSans.bold(size: 12.scale))
        .textAlignment(.center)
    
    init(attachment: Attachment) {
        self.attachment = attachment
        
        super.init(frame: .zero)
        
        makeConstraints()
        initiailize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CCSLAttachmentItemButton {
    func setup(count: Int) {
        countLabel.isHidden = count <= 0
        countLabel.attributedText = String(count).attributed(with: countAttrs)
    }
}

// MARK: Private
private extension CCSLAttachmentItemButton {
    func initiailize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        separator.backgroundColor = marked ? Appearance.mono100 : UIColor(integralRed: 232, green: 232, blue: 232)
    }
}

// MARK: Make constraints
private extension CCSLAttachmentItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.widthAnchor.constraint(equalToConstant: 18.scale),
            countLabel.heightAnchor.constraint(equalToConstant: 18.scale),
            countLabel.centerYAnchor.constraint(equalTo: label.topAnchor),
            countLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CCSLAttachmentItemButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = attachment.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCountLabel() -> UILabel {
        let view = UILabel()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 9.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additiona
private extension CCSLAttachmentItemButton.Attachment {
    var title: String {
        switch self {
        case .internal:
            return "CCSelectLooks.Attachment.Database".localized
        case .custom:
            return "CCSelectLooks.Attachment.YourLooks".localized
        }
    }
}
