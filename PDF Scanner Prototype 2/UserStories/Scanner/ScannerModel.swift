//
//  ScannerModel.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import UIKit
import VisionKit

final class ScannerModel: NSObject, ObservableObject {
    
    // MARK: Properties
    
    @Published
    internal var errorMessage: String?

    @Published
    internal var imageArray: [UIImage] = []
    
    // MARK: Events
    
    func getDocumentCameraViewController() -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = self

        return viewController
    }
    
    func removeImage(image: UIImage) {
        imageArray.removeAll { $0 == image }
    }

}
