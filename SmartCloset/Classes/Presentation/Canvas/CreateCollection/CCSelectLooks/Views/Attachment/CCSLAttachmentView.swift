//
//  CCSLAttachmentView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 09.02.2025.
//

import UIKit
import RxCocoa

final class CCSLAttachmentView: UIView {
    lazy var internalButton = makeButton(attachment: .internal)
    lazy var customButton = makeButton(attachment: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initiailize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CCSLAttachmentView {
    func setup(attachment: CCSLAttachmentItemButton.Attachment) {
        internalButton.marked = attachment == .internal
        customButton.marked = attachment == .custom
    }
    
    func setup(selectedCount: Int) {
        internalButton.setup(count: internalButton.marked ? selectedCount : 0)
        customButton.setup(count: customButton.marked ? selectedCount : 0)
    }
    
    var didSelect: Signal<CCSLAttachmentItemButton.Attachment> {
        Signal<CCSLAttachmentItemButton.Attachment>
            .merge(
                internalButton.rx.tap
                    .asSignal()
                    .compactMap { [weak self] in self?.internalButton.attachment },
                customButton.rx.tap
                    .asSignal()
                    .compactMap { [weak self] in self?.customButton.attachment }
            )
    }
}

// MARK: Private
private extension CCSLAttachmentView {
    func initiailize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension CCSLAttachmentView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            internalButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            internalButton.trailingAnchor.constraint(equalTo: centerXAnchor),
            internalButton.topAnchor.constraint(equalTo: topAnchor),
            internalButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            customButton.leadingAnchor.constraint(equalTo: centerXAnchor),
            customButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            customButton.topAnchor.constraint(equalTo: topAnchor),
            customButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CCSLAttachmentView {
    func makeButton(attachment: CCSLAttachmentItemButton.Attachment) -> CCSLAttachmentItemButton {
        let view = CCSLAttachmentItemButton(attachment: attachment)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
