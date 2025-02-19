//
//  CreateItemViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import RxSwift
import RxCocoa

final class CreateItemViewModel {
    enum Route {
        case close
        case selectCategory(ItemCategory?)
        case selectType(ItemCategory, ItemType?)
        case selectColor(Color?)
        case selectMaterial(Material?)
        case selectPhotoFromGallery
        case takePhoto
        case paygate
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private let initialImage: Driver<CreateItemViewController.Image>
    
    private lazy var discoveryManager = DiscoveryManager()
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(image: CreateItemViewController.Image) {
        self.initialImage = BehaviorRelay(value: image).asDriver()
    }
}

// MARK: Public
extension CreateItemViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapChangePhoto: Signal<Void>
        let newImage: Signal<UIImage>
        let didTapCategory: Signal<Void>
        let didTapType: Signal<Void>
        let didTapColor: Signal<Void>
        let didTapMaterial: Signal<Void>
        let didInputName: Signal<String?>
        let didSelectCategory: Signal<ItemCategory?>
        let didSelectType: Signal<ItemType?>
        let didSelectColor: Signal<Color?>
        let didSelectMaterial: Signal<Material?>
        let didInputComment: Signal<String?>
        let didTapSave: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[CITableElement]>
        let canSave: Driver<Bool>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let imageElement = makeImageElement(
            initialImage: initialImage,
            newImage: input.newImage
        )
        let data = makeData(
            didSelectCategory: input.didSelectCategory,
            didSelectType: input.didSelectType,
            didSelectColor: input.didSelectColor,
            didSelectMaterial: input.didSelectMaterial
        )
        let name = input.didInputName
            .startWith(nil)
            .asDriver(onErrorDriveWith: .never())
        let comments = input.didInputComment
            .startWith(nil)
            .asDriver(onErrorDriveWith: .never())
        
        return Output(
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapCategory: input.didTapCategory,
                didTapType: input.didTapType,
                didTapColor: input.didTapColor,
                didTapMaterial: input.didTapMaterial,
                data: data,
                didTapChangePhoto: input.didTapChangePhoto,
                initialImage: initialImage,
                didTapSave: input.didTapSave,
                comments: comments,
                imageElement: imageElement,
                name: name
            ),
            elements: makeElements(
                imageElement: imageElement,
                data: data
            ),
            canSave: makeCanSave(
                image: imageElement,
                data: data,
                name: name
            ),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension CreateItemViewModel {
    struct Data {
        let category: ItemCategory?
        let type: ItemType?
        let color: Color?
        let material: Material?
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapCategory: Signal<Void>,
        didTapType: Signal<Void>,
        didTapColor: Signal<Void>,
        didTapMaterial: Signal<Void>,
        data: Driver<Data>,
        didTapChangePhoto: Signal<Void>,
        initialImage: Driver<CreateItemViewController.Image>,
        didTapSave: Signal<Void>,
        comments: Driver<String?>,
        imageElement: Driver<CITableImageElement>,
        name: Driver<String?>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let selectCategory = didTapCategory
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(data)
            .map { Route.selectCategory($0.category) }
            .asDriver(onErrorDriveWith: .never())
        
        let selectType = didTapType
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(data)
            .map { data -> Route in
                guard let category = data.category else { return .selectCategory(nil) }
                return .selectType(category, data.type)
            }
        
        let selectColor = didTapColor
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(data)
            .map { Route.selectColor($0.color) }
            .asDriver(onErrorDriveWith: .never())
        
        let didTapMaterial = didTapMaterial
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(data)
            .map { Route.selectMaterial($0.material) }
            .asDriver(onErrorDriveWith: .never())
        
        let changePhoto = didTapChangePhoto
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(initialImage)
            .map { $0.source }
            .map { source -> Route in
                switch source {
                case .gallery:
                    return .selectPhotoFromGallery
                case .takePhoto:
                    return .takePhoto
                }
            }
        
        let save = didTapSave
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(imageElement)
            .withLatestFrom(data) { ($0, $1) }
            .withLatestFrom(comments) { ($0.0, $0.1, $1) }
            .withLatestFrom(name) { ($0.0, $0.1, $0.2, $1) }
            .flatMapLatest { [weak self] image, data, comments, name -> Driver<Route> in
                guard SessionManager().hasActiveSubscriptions() else {
                    return .just(Route.paygate)
                }
                
                guard
                    let self,
                    let imageUrl: URL = {
                        switch image {
                        case .placeholder:
                            return nil
                        case .url(let url):
                            return url
                        }
                    }(),
                    let category = data.category,
                    let type = data.type,
                    let color = data.color,
                    let material = data.material,
                    let name = name
                else { return .never() }
                
                func source() -> Single<Void> {
                    collectionsManager
                        .createItem(
                            name: name,
                            image: imageUrl,
                            category: ItemCategory.RawCode().code(category: category),
                            itemType: type,
                            color: color,
                            material: material.name,
                            comments: comments
                        )
                        .map { item -> Void in
                            guard item != nil else {
                                throw ContentError(.notContent)
                            }
                            
                            return Void()
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .trackActivity(activity)
                    .map { Route.close }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(
                close,
                selectCategory,
                selectType,
                selectColor,
                didTapMaterial,
                changePhoto,
                save
            )
    }
    
    func makeElements(
        imageElement: Driver<CITableImageElement>,
        data: Driver<Data>
    ) -> Driver<[CITableElement]> {
        Driver
            .combineLatest(
                imageElement, data
            ) { image, data -> [CITableElement] in
                [
                    .image(image),
                    .name,
                    .category(data.category),
                    .type(data.type),
                    .color(data.color),
                    .material(data.material),
                    .comments
                ]
            }
    }
    
    func makeImageElement(
        initialImage: Driver<CreateItemViewController.Image>,
        newImage: Signal<UIImage>
    ) -> Driver<CITableImageElement> {
        Driver
            .merge(
                initialImage.map { $0.image },
                newImage.asDriver(onErrorDriveWith: .never())
            )
            .flatMapLatest { [weak self] image -> Driver<CITableImageElement> in
                guard let self else { return .never() }
                
                func source() -> Single<URL> {
                    discoveryManager
                        .upload(image: image, object: .item)
                        .map { result -> URL in
                            guard let url = result.url else {
                                throw ContentError(.notContent)
                            }
                            
                            return url
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .map { CITableImageElement.url($0) }
                    .asDriver(onErrorDriveWith: .never())
                    .startWith(.placeholder)
            }
    }
   
    func makeData(
        didSelectCategory: Signal<ItemCategory?>,
        didSelectType: Signal<ItemType?>,
        didSelectColor: Signal<Color?>,
        didSelectMaterial: Signal<Material?>
    ) -> Driver<Data> {
        Signal
            .combineLatest(
                didSelectCategory.startWith(nil),
                didSelectType.startWith(nil),
                didSelectColor.startWith(nil),
                didSelectMaterial.startWith(nil)
            ) { category, type, color, material -> Data in
                Data(
                    category: category,
                    type: type,
                    color: color,
                    material: material
                )
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeCanSave(
        image: Driver<CITableImageElement>,
        data: Driver<Data>,
        name: Driver<String?>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(image, data, name) { image, data, name -> Bool in
                let hasImage: Bool = {
                    switch image {
                    case .placeholder:
                        return false
                    case .url:
                        return true
                    }
                }()
                
                let hasData: Bool = {
                    (data.category != nil)
                        && (data.type != nil)
                        && (data.color != nil)
                        && (data.material != nil)
                }()
                
                let hasName = !(name ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                
                return hasImage && hasData && hasName
            }
    }
}
