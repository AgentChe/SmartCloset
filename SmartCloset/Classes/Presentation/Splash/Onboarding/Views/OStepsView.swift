//
//  OStepsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import UIKit

final class OStepsView: UIView {
    lazy var welcome1View = makeDivisionView()
    lazy var welcome2View = makeDivisionView()
    lazy var nameView = makeDivisionView()
    lazy var sizeView = makeDivisionView()
    lazy var heightView = makeDivisionView()
    lazy var genderView = makeDivisionView()
    lazy var colorsView = makeDivisionView()
    lazy var occasionsView = makeDivisionView()
    lazy var seasonsView = makeDivisionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OStepsView {
    func update(at slide: OnboardingView.Slide) {
        let highlight = Appearance.main100
        let notHighlight = Appearance.main500
        
        welcome1View.backgroundColor = slide.equalOrGreater(than: .welcome1) ? highlight : notHighlight
        welcome2View.backgroundColor = slide.equalOrGreater(than: .welcome2) ? highlight : notHighlight
        nameView.backgroundColor = slide.equalOrGreater(than: .name) ? highlight : notHighlight
        sizeView.backgroundColor = slide.equalOrGreater(than: .size) ? highlight : notHighlight
        heightView.backgroundColor = slide.equalOrGreater(than: .height) ? highlight : notHighlight
        genderView.backgroundColor = slide.equalOrGreater(than: .gender) ? highlight : notHighlight
        colorsView.backgroundColor = slide.equalOrGreater(than: .colors) ? highlight : notHighlight
        occasionsView.backgroundColor = slide.equalOrGreater(than: .occasions) ? highlight : notHighlight
        seasonsView.backgroundColor = slide.equalOrGreater(than: .seasons) ? highlight : notHighlight
    }
}

// MARK: Private
private extension OStepsView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension OStepsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            welcome1View.leadingAnchor.constraint(equalTo: leadingAnchor),
            welcome1View.topAnchor.constraint(equalTo: topAnchor),
            welcome1View.bottomAnchor.constraint(equalTo: bottomAnchor),
            welcome1View.widthAnchor.constraint(equalTo: welcome2View.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            welcome2View.leadingAnchor.constraint(equalTo: welcome1View.trailingAnchor, constant: 6.scale),
            welcome2View.topAnchor.constraint(equalTo: topAnchor),
            welcome2View.bottomAnchor.constraint(equalTo: bottomAnchor),
            welcome2View.widthAnchor.constraint(equalTo: nameView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameView.leadingAnchor.constraint(equalTo: welcome2View.trailingAnchor, constant: 6.scale),
            nameView.topAnchor.constraint(equalTo: topAnchor),
            nameView.bottomAnchor.constraint(equalTo: bottomAnchor),
            nameView.widthAnchor.constraint(equalTo: sizeView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sizeView.leadingAnchor.constraint(equalTo: nameView.trailingAnchor, constant: 6.scale),
            sizeView.topAnchor.constraint(equalTo: topAnchor),
            sizeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            sizeView.widthAnchor.constraint(equalTo: heightView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            heightView.leadingAnchor.constraint(equalTo: sizeView.trailingAnchor, constant: 6.scale),
            heightView.topAnchor.constraint(equalTo: topAnchor),
            heightView.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightView.widthAnchor.constraint(equalTo: genderView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            genderView.leadingAnchor.constraint(equalTo: heightView.trailingAnchor, constant: 6.scale),
            genderView.topAnchor.constraint(equalTo: topAnchor),
            genderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            genderView.widthAnchor.constraint(equalTo: colorsView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            colorsView.leadingAnchor.constraint(equalTo: genderView.trailingAnchor, constant: 6.scale),
            colorsView.topAnchor.constraint(equalTo: topAnchor),
            colorsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            colorsView.widthAnchor.constraint(equalTo: occasionsView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            occasionsView.leadingAnchor.constraint(equalTo: colorsView.trailingAnchor, constant: 6.scale),
            occasionsView.topAnchor.constraint(equalTo: topAnchor),
            occasionsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            occasionsView.widthAnchor.constraint(equalTo: seasonsView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            seasonsView.leadingAnchor.constraint(equalTo: occasionsView.trailingAnchor, constant: 6.scale),
            seasonsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            seasonsView.topAnchor.constraint(equalTo: topAnchor),
            seasonsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OStepsView {
    func makeDivisionView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 2.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension OnboardingView.Slide {
    func equalOrGreater(than slide: OnboardingView.Slide) -> Bool {
        rawValue >= slide.rawValue
    }
}
