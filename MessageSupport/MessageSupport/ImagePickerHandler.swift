//
//  ImagePickerHandler.swift
//  MessageSupport
//
//  Created by Esraa Gamal on 6/12/21.
//

import UIKit
import BSImagePicker
import Photos

protocol ImagePickerDelegate: class {
    func didFinishPicking(_ photos: [UIImage])
}

class ImagePickerHandler {
    
    weak var presentingViewController: UIViewController?
    weak var delegate: ImagePickerDelegate?
    
    init(presentingViewController: UIViewController & ImagePickerDelegate) {
        self.presentingViewController = presentingViewController
        self.delegate = presentingViewController
    }
    
    private func checkPermissionForGallery(_ authorizationComplete: @escaping () -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        
        case .authorized:
            authorizationComplete()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    authorizationComplete()
                }
            }
        default: //.denied, .restricted: // open settings
            self.requestAuthorization()
        }
    }
    
    private func requestAuthorization() {
        // initialise a pop up for using later
        let alertController = UIAlertController(title: "Gallery Permisson",
                                                message:"give accesss to open gallery",
                                                preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        presentingViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func selectPhotos() {
        checkPermissionForGallery{ [weak self] in
            self?.startImagePicker()
        }
        
    }
    
    private func startImagePicker() {
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5
        imagePicker.settings.selection.unselectOnReachingMax = true
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        presentingViewController?.presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: {(assets) in
            // User finished selection assets.
            let group = DispatchGroup()
            var photos = [UIImage]()
            
            let options = PHImageRequestOptions()
                        options.version = .current
                        options.resizeMode = .exact
                        options.deliveryMode = .highQualityFormat
                        options.isNetworkAccessAllowed = true
                        options.isSynchronous = true
            
            for asset in assets {
                group.enter()
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: PHImageManagerMaximumSize,
                                                      contentMode: .aspectFit,
                                                      options: options) { (image, info) in
                    // Do something with image
                    if let photo = image {
                        photos.append(photo)
                        group.leave()
                    } else {
                        group.leave()
                    }
                }
            }
            group.notify(queue: DispatchQueue.global()) { [weak self] in
                self?.delegate?.didFinishPicking(photos)
            }
        })
    }
}
