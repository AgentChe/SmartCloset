//
//  ChangeGenderView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

import UIKit

final class ChangeGenderView: ChangeProfileFieldView {
    lazy var femaleButton = makeGenderButton(gender: .female)
    lazy var maleButton = makeGenderButton(gender: .male)
    
    private lazy var genderButtons = [femaleButton, maleButton]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeField() -> ChangeProfileFieldView.ChangedField? {
        guard let gender = genderButtons.first(where: { $0.marked })?.gender else { return nil }
        return .gender(gender)
    }
    
    override func canSave() -> Bool {
        genderButtons.contains { $0.marked }
    }
}

// MARK: Public
extension ChangeGenderView {
    func setup(gender: Gender?) {
        genderButtons.forEach { $0.marked = $0.gender == gender }
        
        updateSaveEnable()
    }
}

// MARK: Private
private extension ChangeGenderView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
    
    @objc
    func genderTapped(sender: UIButton) {
        guard let genderButton = sender as? OGenderButton else { return }
        
        genderButtons.forEach { $0.marked = $0.gender == genderButton.gender }
        
        updateSaveEnable()
    }
}

// MARK: Make constraints
private extension ChangeGenderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            femaleButton.widthAnchor.constraint(equalToConstant: 171.scale),
            femaleButton.heightAnchor.constraint(equalToConstant: 171.scale),
            femaleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            femaleButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            maleButton.widthAnchor.constraint(equalToConstant: 171.scale),
            maleButton.heightAnchor.constraint(equalToConstant: 171.scale),
            maleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            maleButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChangeGenderView {
    func makeGenderButton(gender: Gender) -> OGenderButton {
        let view = OGenderButton(gender: gender)
        view.addTarget(self, action: #selector(genderTapped(sender:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
