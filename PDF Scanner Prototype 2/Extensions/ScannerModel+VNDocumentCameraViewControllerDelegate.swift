//
//  ScannerModel+VNDocumentCameraViewControllerDelegate.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import Foundation
import VisionKit

extension ScannerModel: VNDocumentCameraViewControllerDelegate {

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let scannedPagesCount = scan.pageCount
        
        for index in 0..<scannedPagesCount {
            self.imageArray.append(scan.imageOfPage(at:index))
        }

        controller.dismiss(animated: true)
    }

}
