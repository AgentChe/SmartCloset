//
//  ChoosePhotoFromGallery.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit
import PhotosUI

final class ChoosePhotoFromGallery {
    private let result: (UIImage) -> Void
    
    init(result: @escaping (UIImage) -> Void) {
        self.result = result
    }
    
    func choose(from: UIViewController) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .automatic
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        from.present(picker, animated: true)
    }
}

// MARK: PHPickerViewControllerDelegate
extension ChoosePhotoFromGallery: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results
            .map (\.itemProvider)
            .filter { $0.canLoadObject(ofClass: UIImage.self) }
            .first
        guard let itemProvider else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            if let image = image as? UIImage {
                DispatchQueue.main.async { [weak self] in
                    self?.result(image)
                }
            }
        }
    }
}
