//
//  TakePhoto.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit
import AVFoundation

final class TakePhoto: NSObject {
    private let result: (UIImage) -> Void
    
    init(result: @escaping (UIImage) -> Void) {
        self.result = result
    }
    
    func take(from: UIViewController) {
        authorized { authorized in
            guard authorized else { return }
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            from.present(imagePicker, animated: true)
        }
    }
}

// MARK: UIImagePickerControllerDelegate
extension TakePhoto: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage) else { return }
        
        picker.dismiss(animated: true) { [weak self] in
            self?.result(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: UINavigationControllerDelegate
extension TakePhoto: UINavigationControllerDelegate {}

// MARK: Private
private extension TakePhoto {
    func authorized(result: @escaping (Bool) -> Void) {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                DispatchQueue.main.async {
                    result(authorized)
                }
            }
        case .authorized:
            result(true)
        default:
            result(false)
        }
    }
}
