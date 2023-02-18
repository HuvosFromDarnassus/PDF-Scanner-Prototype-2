//
//  ConvertService.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 18.02.2023.
//

import UIKit
import PDFKit

protocol ConvertService {
    
    func convertPDFToImage(with url: URL) -> UIImage?
    func convertImageToPDF(with image: UIImage, using url: URL) -> PDFDocument?
    
}

final class ConvertServiceImplementation: ConvertService {
    
    // MARK: ConvertService
    
    func convertPDFToImage(with url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL),
              let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }

        return img
    }
    
    func convertImageToPDF(with image: UIImage, using url: URL) -> PDFDocument? {
        guard let pdfPage = PDFPage(image: image),
              let pdfDocument = PDFDocument(url: url) else { return nil }
        pdfDocument.insert(pdfPage, at: 0)

        return pdfDocument
    }
    
}
