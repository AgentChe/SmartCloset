//
//  SIFCLAttachmentView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 06.02.2025.
//

import UIKit
import RxCocoa

final class SIFCLAttachmentView: UIView {
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
extension SIFCLAttachmentView {
    func setup(attachment: SIFCLAttachmentItemButton.Attachment) {
        internalButton.marked = attachment == .internal
        customButton.marked = attachment == .custom
    }
    
    var didSelect: Signal<SIFCLAttachmentItemButton.Attachment> {
        Signal<SIFCLAttachmentItemButton.Attachment>
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
private extension SIFCLAttachmentView {
    func initiailize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension SIFCLAttachmentView {
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
private extension SIFCLAttachmentView {
    func makeButton(attachment: SIFCLAttachmentItemButton.Attachment) -> SIFCLAttachmentItemButton {
        let view = SIFCLAttachmentItemButton(attachment: attachment)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
