//
//  ImagePickerIntent.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

final class ImagePickerLauncherIntent {
    let alertController: UIAlertController
    
    init(libraryCompletion: @escaping (UIAlertAction) -> Void, cameraCompletion: @escaping (UIAlertAction) -> Void) {
        alertController = UIAlertController(title: "Select source", message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = .carfieBlue
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: cameraCompletion)
        let libraryAction = UIAlertAction(title: "Photo library", style: .default, handler: libraryCompletion)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
    }
    
    func execute(via presenter: UIViewController) {
        presenter.present(alertController, animated: true)
    }
}

final class ImagePickerIntent {
    let imagePickerController: UIImagePickerController
    
    init?(for sourceType: UIImagePickerController.SourceType, allowsEditing: Bool = true) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return nil }
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.sourceType = sourceType
        self.imagePickerController.allowsEditing = allowsEditing
    }
    
    func execute(via presenter: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate, completion: (() -> Void)? = nil) {
        imagePickerController.delegate = presenter
        presenter.present(imagePickerController, animated: true, completion: completion)
    }
}
