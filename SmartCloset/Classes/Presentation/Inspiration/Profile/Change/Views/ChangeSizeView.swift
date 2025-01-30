//
//  ChangeSizeView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

import UIKit

final class ChangeSizeView: ChangeProfileFieldView {
    lazy var xxsButton = makeSizeButton(size: .XXS)
    lazy var xsButton = makeSizeButton(size: .XS)
    lazy var sButton = makeSizeButton(size: .S)
    lazy var mButton = makeSizeButton(size: .M)
    lazy var lButton = makeSizeButton(size: .L)
    lazy var xlButton = makeSizeButton(size: .XL)
    lazy var xxlButton = makeSizeButton(size: .XXL)
    
    private lazy var sizeButtons = [
        xxsButton,
        xsButton,
        sButton,
        mButton,
        lButton,
        xlButton,
        xxlButton
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeField() -> ChangeProfileFieldView.ChangedField? {
        guard let size = sizeButtons.first(where: { $0.marked })?.object else { return nil }
        return .size(size)
    }
    
    override func canSave() -> Bool {
        sizeButtons.contains { $0.marked }
    }
}

// MARK: Public
extension ChangeSizeView {
    func setup(size: Size?) {
        guard let size else { return }
        
        sizeButtons.forEach { $0.marked = $0.object == size }
        
        updateSaveEnable()
    }
}

// MARK: Private
private extension ChangeSizeView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
    
    @objc
    func sizeButtonTapped(sender: UIButton) {
        guard let sizeButton = sender as? OSelectTextButton<Size> else { return }
        
        sizeButtons.forEach { $0.marked = $0.object == sizeButton.object }
        
        updateSaveEnable()
    }
}

// MARK: Make constraints
private extension ChangeSizeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            xxsButton.widthAnchor.constraint(equalToConstant: 82.scale),
            xxsButton.heightAnchor.constraint(equalToConstant: 48.scale),
            xxsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            xxsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            xsButton.widthAnchor.constraint(equalToConstant: 82.scale),
            xsButton.heightAnchor.constraint(equalToConstant: 48.scale),
            xsButton.leadingAnchor.constraint(equalTo: xxsButton.trailingAnchor, constant: 10.scale),
            xsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            sButton.widthAnchor.constraint(equalToConstant: 82.scale),
            sButton.heightAnchor.constraint(equalToConstant: 48.scale),
            sButton.leadingAnchor.constraint(equalTo: xsButton.trailingAnchor, constant: 10.scale),
            sButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            mButton.widthAnchor.constraint(equalToConstant: 82.scale),
            mButton.heightAnchor.constraint(equalToConstant: 48.scale),
            mButton.leadingAnchor.constraint(equalTo: sButton.trailingAnchor, constant: 10.scale),
            mButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            lButton.widthAnchor.constraint(equalToConstant: 112.scale),
            lButton.heightAnchor.constraint(equalToConstant: 48.scale),
            lButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            lButton.topAnchor.constraint(equalTo: xxsButton.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            xlButton.widthAnchor.constraint(equalToConstant: 112.scale),
            xlButton.heightAnchor.constraint(equalToConstant: 48.scale),
            xlButton.leadingAnchor.constraint(equalTo: lButton.trailingAnchor, constant: 10.scale),
            xlButton.topAnchor.constraint(equalTo: xxsButton.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            xxlButton.widthAnchor.constraint(equalToConstant: 112.scale),
            xxlButton.heightAnchor.constraint(equalToConstant: 48.scale),
            xxlButton.leadingAnchor.constraint(equalTo: xlButton.trailingAnchor, constant: 10.scale),
            xxlButton.topAnchor.constraint(equalTo: xxsButton.bottomAnchor, constant: 10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChangeSizeView {
    func makeSizeButton(size: Size) -> OSelectTextButton<Size> {
        let view = OSelectTextButton<Size>(object: size, title: Size.DefaultLocalized(size: size).name)
        view.addTarget(self, action: #selector(sizeButtonTapped(sender:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
