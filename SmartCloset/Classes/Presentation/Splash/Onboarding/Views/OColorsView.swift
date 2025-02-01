//
//  OColorsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import UIKit
import RxSwift

final class OColorsView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var tableView = makeTableView()
    lazy var nextButton = makeNextButton()
    lazy var skipButton = makeSkipButton()
    
    private lazy var nextButtonEnableAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.bold(size: 18.scale))
    private lazy var nextButtonDisableAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.4))
        .font(Fonts.SofiaSans.bold(size: 18.scale))
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var discoveryManager = DiscoveryManager()
    
    private let complete: ([String]?) -> Void
    
    init(complete: @escaping ([String]?) -> Void) {
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
private extension OColorsView {
    func initialize() {
        backgroundColor = Appearance.mono200
        
        tableView.didChangeSelected = { [weak self] in
            self?.updateNextEnable()
        }
        
        discoveryManager
            .obtainColors(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(self) { base, colors in
                let elements = (colors ?? []).map { OTableElement(entity: .color($0)) }
                base.tableView.setup(elements: elements)
                
                base.updateNextEnable()
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func nextTapped() {
        let colors = tableView
            .elements.filter { $0.marked }
            .compactMap { element -> Color? in
                guard case let .color(color) = element.entity else { return nil }
                return color
            }
            .map { $0.name }
        
        complete(colors)
    }
    
    @objc
    func skipTapped() {
        complete(nil)
    }
    
    func updateNextEnable() {
        let enable = tableView.elements.contains(where: { $0.marked })
        
        nextButton.isEnabled = enable
        nextButton.backgroundColor = enable ? Appearance.main100 : Appearance.main400

        let attrs = enable ? nextButtonEnableAttrs : nextButtonDisableAttrs
        nextButton.setAttributedTitle("Next".localized.attributed(with: attrs), for: .normal)
    }
}

// MARK: Make constraints
private extension OColorsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -2.scale)
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
private extension OColorsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 22.scale))
            .lineHeight(26.scale)
            .letterSpacing(-0.32.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Colors.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> OTableView {
        let view = OTableView(selectRule: .multi)
        view.contentInset = UIEdgeInsets(vertical: 30.scale)
        view.setContentOffset(CGPoint(x: 0, y: -30.scale), animated: false)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
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
