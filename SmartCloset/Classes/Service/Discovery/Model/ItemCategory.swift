//
//  ItemCategory.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 26.01.2025.
//

enum ItemCategory: CaseIterable {
    case tops
    case bottoms
    case shoes
    case bags
    case accessories
}

typealias ItemType = String

// MARK: Public
extension ItemCategory {
    struct RawCode {
        func code(category: ItemCategory) -> String {
            switch category {
            case .tops:
                return "Tops"
            case .bottoms:
                return "Bottoms"
            case .shoes:
                return "Shoes"
            case .bags:
                return "Bags"
            case .accessories:
                return "Accessories"
            }
        }
    }
    
    struct DefaultIcon {
        func assetIconName(category: ItemCategory) -> String {
            switch category {
            case .tops:
                return "Category.Top"
            case .bottoms:
                return "Category.Bottom"
            case .shoes:
                return "Category.Shoes"
            case .bags:
                return "Category.Bag"
            case .accessories:
                return "Category.Accessory"
            }
        }
    }
    
    struct DefaultLocalized {
        func name(category: ItemCategory) -> String {
            switch category {
            case .tops:
                return "ItemCategory.Tops".localized
            case .bottoms:
                return "ItemCategory.Bottoms".localized
            case .shoes:
                return "ItemCategory.Shoes".localized
            case .bags:
                return "ItemCategory.Bags".localized
            case .accessories:
                return "ItemCategory.Accessories".localized
            }
        }
    }
    
    struct TypesFabric {
        func list(for category: ItemCategory) -> [ItemType] {
            switch category {
            case .tops:
                return [
                    "ItemType.Top.Blouse".localized,
                    "ItemType.Top.Button-up Shirt".localized,
                    "ItemType.Top.Cardigan".localized,
                    "ItemType.Top.Crop Top".localized,
                    "ItemType.Top.Hoodie".localized,
                    "ItemType.Top.Jacket".localized,
                    "ItemType.Top.Shirt".localized,
                    "ItemType.Top.Sweater".localized,
                    "ItemType.Top.T-shirt".localized,
                    "ItemType.Top.Tank Top".localized,
                    "ItemType.Top.Long-sleeve".localized,
                    "ItemType.Top.Other".localized
                ]
            case .bottoms:
                return [
                    "ItemType.Bottoms.Chinos".localized,
                    "ItemType.Bottoms.Jeans".localized,
                    "ItemType.Bottoms.Leggings".localized,
                    "ItemType.Bottoms.Shorts".localized,
                    "ItemType.Bottoms.Skirt".localized,
                    "ItemType.Bottoms.Sweatpants".localized,
                    "ItemType.Bottoms.Trousers".localized,
                    "ItemType.Bottoms.Cargo Pants".localized,
                    "ItemType.Bottoms.Capri Pants".localized,
                    "ItemType.Bottoms.Other".localized
                ]
            case .shoes:
                return [
                    "ItemType.Shoes.Ankle Boots".localized,
                    "ItemType.Shoes.Ballet Flats".localized,
                    "ItemType.Shoes.Flip-flops".localized,
                    "ItemType.Shoes.Loafers".localized,
                    "ItemType.Shoes.Sandals".localized,
                    "ItemType.Shoes.Sneakers".localized,
                    "ItemType.Shoes.Stilettos".localized,
                    "ItemType.Shoes.Wedges".localized,
                    "ItemType.Shoes.Oxfords".localized,
                    "ItemType.Shoes.Other".localized
                ]
            case .bags:
                return [
                    "ItemType.Bags.Backpack".localized,
                    "ItemType.Bags.Clutch".localized,
                    "ItemType.Bags.Crossbody Bag".localized,
                    "ItemType.Bags.Handbag".localized,
                    "ItemType.Bags.Satchel".localized,
                    "ItemType.Bags.Shoulder Bag".localized,
                    "ItemType.Bags.Tote Bag" .localized,
                    "ItemType.Bags.Duffel Bag".localized,
                    "ItemType.Bags.Messenger Bag".localized,
                    "ItemType.Bags.Other".localized
                ]
            case .accessories:
                return [
                    "ItemType.Accessories.Belt".localized,
                    "ItemType.Accessories.Bracelet".localized,
                    "ItemType.Accessories.Earrings".localized,
                    "ItemType.Accessories.Rings".localized,
                    "ItemType.Accessories.Gloves".localized,
                    "ItemType.Accessories.Hat".localized,
                    "ItemType.Accessories.Necklace".localized,
                    "ItemType.Accessories.Scarf".localized,
                    "ItemType.Accessories.Sunglasses".localized,
                    "ItemType.Accessories.Watch".localized,
                    "ItemType.Accessories.Tie".localized,
                    "ItemType.Accessories.Other".localized
                ]
            }
        }
    }
}
