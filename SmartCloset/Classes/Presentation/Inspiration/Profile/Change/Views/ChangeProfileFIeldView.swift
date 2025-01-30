//
//  ChangeProfileFIeldView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

import UIKit
import RxSwift
import RxCocoa

class ChangeProfileFieldView: UIView {
    enum ChangedField {
        case name(String)
        case size(Size)
        case gender(Gender)
        case height(Height)
        case occasions([Occasion])
        case seasons([Season])
    }
    
    lazy var saveButton = makeSaveButton()
    lazy var preloader = makePreloader()
    
    private lazy var changedFieldTrigger = PublishRelay<ChangedField>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        updateSaveEnable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeField() -> ChangedField? {
        fatalError("Should override")
    }
    
    func canSave() -> Bool {
        fatalError("Should override")
    }
}

// MARK: Public
extension ChangeProfileFieldView {
    func activity(_ activity: Bool) {
        saveButton.isHidden = activity
        activity ? preloader.startAnimating() : preloader.stopAnimating()
    }
    
    func updateSaveEnable() {
        let enable = canSave()
        
        saveButton.isEnabled = enable
        saveButton.alpha = enable ? 1 : 0.5
    }
    
    var changedField: Signal<ChangedField> {
        changedFieldTrigger.asSignal()
    }
}

// MARK: Private
private extension ChangeProfileFieldView {
    @objc
    func saveTapped() {
        guard let field = makeField() else { return }
        
        changedFieldTrigger.accept(field)
    }
}

// MARK: Make constraints
private extension ChangeProfileFieldView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 52.scale),
            saveButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 32.scale),
            preloader.heightAnchor.constraint(equalToConstant: 32.scale),
            preloader.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ChangeProfileFieldView {
    func makeSaveButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Save".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main100
        view.layer.cornerRadius = 3.scale
        view.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.stopAnimating()
        view.hidesWhenStopped = true
        view.color = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
