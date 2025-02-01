//
//  Material.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

struct Material {
    let name: String
}

// MARK: Public
extension Material {
    struct Fabric {
        func list() -> [Material] {
            [
                Material(name: "Material.Wool".localized),
                Material(name: "Material.Acrylic".localized),
                Material(name: "Material.Cashmere".localized),
                Material(name: "Material.Cotton".localized),
                Material(name: "Material.Fur".localized),
                Material(name: "Material.Hemp".localized),
                Material(name: "Material.Leather".localized),
                Material(name: "Material.Microfiber".localized),
                Material(name: "Material.Nylon".localized),
                Material(name: "Material.Polyester".localized),
                Material(name: "Material.Rayon".localized),
                Material(name: "Material.Spandex (Lycra)".localized),
                Material(name: "Material.Suede".localized),
                Material(name: "Material.Silk".localized)
            ]
        }
    }
}
