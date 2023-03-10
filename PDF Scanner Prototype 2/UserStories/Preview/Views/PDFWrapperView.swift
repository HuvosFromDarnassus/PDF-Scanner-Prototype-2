//
//  PDFWrapperView.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import SwiftUI
import PDFKit

struct PDFWrapperView: UIViewRepresentable {
    
    // MARK: Properties
    
    private let url: URL
    
    // MARK: Initializers
    
    init(_ url: URL) {
        self.url = url
    }
    
    // MARK: Events
    
    func makeUIView(context: UIViewRepresentableContext<PDFWrapperView>) -> PDFWrapperView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.pageBreakMargins = UIEdgeInsets(top: 50, left: 30, bottom: 50, right:30)
        pdfView.autoScales = true
        
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFWrapperView>) {}
    
}
