//
//  OSizeView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import UIKit

final class OSizeView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var xxsButton = makeSizeButton(size: .XXS)
    lazy var xsButton = makeSizeButton(size: .XS)
    lazy var sButton = makeSizeButton(size: .S)
    lazy var mButton = makeSizeButton(size: .M)
    lazy var lButton = makeSizeButton(size: .L)
    lazy var xlButton = makeSizeButton(size: .XL)
    lazy var xxlButton = makeSizeButton(size: .XXL)
    lazy var nextButton = makeNextButton()
    lazy var skipButton = makeSkipButton()
    
    private lazy var sizeButtons = [
        xxsButton,
        xsButton,
        sButton,
        mButton,
        lButton,
        xlButton,
        xxlButton
    ]
    
    private lazy var nextButtonEnableAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.bold(size: 18.scale))
    private lazy var nextButtonDisableAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.4))
        .font(Fonts.SofiaSans.bold(size: 18.scale))
    
    private let complete: (Size?) -> Void
    
    init(complete: @escaping (Size?) -> Void) {
        self.complete = complete
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        changeEnableNextButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSizeView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
    
    @objc
    func sizeButtonTapped(sender: UIButton) {
        guard let sizeButton = sender as? OSelectTextButton<Size> else { return }
        
        sizeButtons.forEach { $0.marked = $0.object == sizeButton.object }
        
        changeEnableNextButton()
    }
    
    @objc
    func changeEnableNextButton() {
        let enable = sizeButtons.contains { $0.marked }
        
        nextButton.isEnabled = enable
        nextButton.backgroundColor = enable ? Appearance.main100 : Appearance.main400
        
        let attrs = enable ? nextButtonEnableAttrs : nextButtonDisableAttrs
        nextButton.setAttributedTitle("Next".localized.attributed(with: attrs), for: .normal)
    }
    
    @objc
    func nextTapped() {
        guard let size = sizeButtons.first(where: { $0.marked })?.object else { return }
        
        complete(size)
    }
    
    @objc
    func skipTapped() {
        complete(nil)
    }
}

// MARK: Make constraints
private extension OSizeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            xxsButton.widthAnchor.constraint(equalToConstant: 82.scale),
            xxsButton.heightAnchor.constraint(equalToConstant: 48.scale),
            xxsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            xxsButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            xsButton.widthAnchor.constraint(equalToConstant: 82.scale),
            xsButton.heightAnchor.constraint(equalToConstant: 48.scale),
            xsButton.leadingAnchor.constraint(equalTo: xxsButton.trailingAnchor, constant: 10.scale),
            xsButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            sButton.widthAnchor.constraint(equalToConstant: 82.scale),
            sButton.heightAnchor.constraint(equalToConstant: 48.scale),
            sButton.leadingAnchor.constraint(equalTo: xsButton.trailingAnchor, constant: 10.scale),
            sButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            mButton.widthAnchor.constraint(equalToConstant: 82.scale),
            mButton.heightAnchor.constraint(equalToConstant: 48.scale),
            mButton.leadingAnchor.constraint(equalTo: sButton.trailingAnchor, constant: 10.scale),
            mButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32.scale)
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
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nextButton.heightAnchor.constraint(equalToConstant: 52.scale),
            nextButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            skipButton.heightAnchor.constraint(equalToConstant: 52.scale),
            skipButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSizeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 22.scale))
            .lineHeight(26.scale)
            .letterSpacing(-0.32.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Size.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.32.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Size.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSizeButton(size: Size) -> OSelectTextButton<Size> {
        let view = OSelectTextButton<Size>(object: size, title: Size.DefaultLocalized(size: size).name)
        view.addTarget(self, action: #selector(sizeButtonTapped(sender:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> UIButton {
        let view = UIButton()
        view.layer.cornerRadius = 3.scale
        view.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSkipButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Skip".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main400
        view.layer.cornerRadius = 3.scale
        view.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
