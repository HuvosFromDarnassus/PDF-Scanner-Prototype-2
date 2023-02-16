//
//  PDFKitRepresentedView.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import SwiftUI
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    
    let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.pageBreakMargins = UIEdgeInsets(top: 50, left: 30, bottom: 50, right:30)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}
