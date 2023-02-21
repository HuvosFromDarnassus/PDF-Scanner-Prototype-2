//
//  ExtractService.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 19.02.2023.
//

import PDFKit
import Vision

protocol ExtractService {
    
    func extractText(from documentImage: UIImage?) -> String
    
}

final class ExtractServiceImplemenation: ExtractService {
    
    // MARK: ExtractService
    
    func extractText(from documentImage: UIImage?) -> String {
        guard let documentImage = documentImage,
              let documentCGImage = documentImage.cgImage else {
            return ""
        }
        
        var extrcatedText = ""
        tryRecognizeText(from: documentCGImage, fill: &extrcatedText)
        
        return extrcatedText
    }
    
    // MARK: Private
    
    private func tryRecognizeText(from documentCGImage: CGImage, fill extrcatedText: inout String) {
        let requestHandler = VNImageRequestHandler(cgImage: documentCGImage, options: [:])
        let textRecognitionRequest = VNRecognizeTextRequest()
        textRecognitionRequest.recognitionLevel = .accurate
        
        do {
            try requestHandler.perform([textRecognitionRequest])
            
            let recognizedText = textRecognitionRequest.results?
                .compactMap({ $0 })
                .compactMap({ $0.topCandidates(1).first?.string })
                .joined(separator: "\n")
            
            extrcatedText = recognizedText!
        } catch {
            extrcatedText = error.localizedDescription
        }
    }
    
}
