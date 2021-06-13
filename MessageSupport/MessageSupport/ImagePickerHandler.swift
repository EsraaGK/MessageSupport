//
//  ImagePickerHandler.swift
//  MessageSupport
//
//  Created by Esraa Gamal on 6/12/21.
//

import UIKit
import BSImagePicker
import Photos

class ImagePickerHandler {
    
    func selectPhotos(over viewcontroller: UIViewController,
                      with completion: @escaping([UIImage]) -> Void) {
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5
        imagePicker.settings.selection.unselectOnReachingMax = true
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        viewcontroller.presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: {(assets) in
            // User finished selection assets.
            let group = DispatchGroup()
           var photos = [UIImage]()
            for asset in assets {
                group.enter()
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: PHImageManagerMaximumSize,
                                                      contentMode: .aspectFit,
                                                      options: nil) { (image, info) in
                    // Do something with image
                    if let photo = image {
                        photos.append(photo)
                        group.leave()
                    } else {
                        group.leave()
                    }
                }
            }
            group.notify(queue: DispatchQueue.global()) {
                completion(photos)
            }
        })
    }
}
