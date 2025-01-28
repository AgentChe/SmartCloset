//
//  OGenderView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import UIKit

final class OGenderView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var femaleButton = makeGenderButton(gender: .female)
    lazy var maleButton = makeGenderButton(gender: .male)
    lazy var nextButton = makeNextButton()
    lazy var skipButton = makeSkipButton()
    
    private lazy var genderButtons = [femaleButton, maleButton]
    
    private lazy var nextButtonEnableAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.bold(size: 18.scale))
    private lazy var nextButtonDisableAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.4))
        .font(Fonts.SofiaSans.bold(size: 18.scale))
    
    private let complete: (Gender?) -> Void
    
    init(complete: @escaping (Gender?) -> Void) {
        self.complete = complete
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        updateNextEnable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OGenderView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
    
    @objc
    func genderTapped(sender: UIButton) {
        guard let genderButton = sender as? OGenderButton else { return }
        
        genderButtons.forEach { $0.marked = $0.gender == genderButton.gender }
        
        updateNextEnable()
    }
    
    @objc
    func nextTapped() {
        guard let gender = genderButtons.first(where: { $0.marked })?.gender else { return }
        
        complete(gender)
    }
    
    @objc
    func skipTapped() {
        complete(nil)
    }
    
    func updateNextEnable() {
        let enable = genderButtons.contains { $0.marked }
        
        nextButton.isEnabled = enable
        nextButton.backgroundColor = enable ? Appearance.main100 : Appearance.main400

        let attrs = enable ? nextButtonEnableAttrs : nextButtonDisableAttrs
        nextButton.setAttributedTitle("Next".localized.attributed(with: attrs), for: .normal)
    }
}

// MARK: Make constraints
private extension OGenderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            femaleButton.widthAnchor.constraint(equalToConstant: 171.scale),
            femaleButton.heightAnchor.constraint(equalToConstant: 171.scale),
            femaleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            femaleButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            maleButton.widthAnchor.constraint(equalToConstant: 171.scale),
            maleButton.heightAnchor.constraint(equalToConstant: 171.scale),
            maleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            maleButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30.scale)
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
private extension OGenderView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 22.scale))
            .lineHeight(26.scale)
            .letterSpacing(-0.32.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Gender.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGenderButton(gender: Gender) -> OGenderButton {
        let view = OGenderButton(gender: gender)
        view.addTarget(self, action: #selector(genderTapped(sender:)), for: .touchUpInside)
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
