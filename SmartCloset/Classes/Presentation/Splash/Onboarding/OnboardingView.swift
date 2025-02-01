//
//  OnboardingView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OnboardingView: UIView {
    enum Slide: Int {
        case welcome1
        case welcome2
        case name
        case size
        case height
        case gender
        case colors
        case occasions
        case seasons
    }
    
    lazy var container = makeContainer()
    lazy var stepsView = makeStepsView()
    
    private lazy var slidesViews: [Slide: UIView] = [
        .welcome1: OWelcome1View { [weak self] in
            self?.scroll(from: .welcome1, to: .welcome2)
        },
        .welcome2: OWelcome2View { [weak self] in
            self?.scroll(from: .welcome2, to: .name)
        },
        .name: ONameView { [weak self] name in
            self?.collector.setup(name: name)
            self?.scroll(from: .name, to: .size)
        },
        .size: OSizeView { [weak self] size in
            self?.collector.setup(size: size)
            self?.scroll(from: .size, to: .height)
        },
        .height: OHeightView { [weak self] height in
            self?.collector.setup(height: height)
            self?.scroll(from: .height, to: .gender)
        },
        .gender: OGenderView { [weak self] gender in
            self?.collector.setup(gender: gender)
            self?.scroll(from: .gender, to: .colors)
        },
        .colors: OColorsView { [weak self] colors in
            self?.collector.setup(interestedColors: colors)
            self?.scroll(from: .colors, to: .occasions)
        },
        .occasions: OOccasionsView { [weak self] occasions in
            self?.collector.setup(occasions: occasions)
            self?.scroll(from: .occasions, to: .seasons)
        },
        .seasons: OSeasonsView { [weak self] season in
            guard let self else { return }
            
            collector.setup(season: season)
            finish(collector.make())
        }
    ]
    
    private lazy var collector = OProfileCollector()
    
    private let finish: (Profile) -> Void
    
    init(finish: @escaping (Profile) -> Void) {
        self.finish = finish
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        slidesViews.map { $1 }.enumerated().forEach { [weak self] index, slideView in
            guard let self else { return }
            
            slideView.frame.size = bounds.size
        }
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        backgroundColor = Appearance.mono200
        
        if let view = slidesViews[.welcome1] {
            view.frame.origin = CGPoint.zero
            container.addSubview(view)
        }
        
        stepsView.update(at: .welcome1)
    }
    
    func scroll(from: Slide, to: Slide) {
        guard let currentView = slidesViews[from], let scrollToView = slidesViews[to] else { return }
        
        scrollToView.frame.origin = CGPoint(x: bounds.size.width, y: 0)
        
        container.addSubview(scrollToView)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self else { return }
            
            currentView.frame.origin = CGPoint(x: -bounds.size.width, y: 0)
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { [weak self] result in
            guard let self = self else { return }
            
            currentView.removeFromSuperview()
            
            stepsView.update(at: to)
        })
    }
}

// MARK: Make constraints
private extension OnboardingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stepsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            stepsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            stepsView.heightAnchor.constraint(equalToConstant: 6.scale),
            stepsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OnboardingView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStepsView() -> OStepsView {
        let view = OStepsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
