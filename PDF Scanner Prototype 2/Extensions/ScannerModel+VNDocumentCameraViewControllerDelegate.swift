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
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        print("Did Finish With Scan.")
        for i in 0..<scan.pageCount {
            self.imageArray.append(scan.imageOfPage(at:i))
        }
        controller.dismiss(animated: true, completion: nil)
    }

}
