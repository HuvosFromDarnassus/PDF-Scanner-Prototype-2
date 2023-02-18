//
//  PDFPreviewView.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import SwiftUI
import PDFKit
import PencilKit

struct PDFPreviewView: View {
    
    // MARK: Properties
    
    internal let filesService: FileService
    internal let convertService: ConvertService
    
    var url: URL
    var fileName: String
    
    @Binding
    var isPDFOpenView: Bool
    
    @State
    private var isEditorSharePresent = false
    @State
    private var isPrintPDF = false
    @State
    private var isEditPDF = false

    @State
    private var pdfView = PDFView()
    
    // MARK: Layout
    
    var body: some View {
        VStack {
            PDFPreviewNavigationBar(url: url, fileName: fileName, isPDFOpenView: $isPDFOpenView, isEditPDF: $isEditPDF)
            .padding()
            
            Spacer()
            
            if isEditPDF, let convertedImageFromPDF = convertService.convertPDFToImage(with: url) {
                PDFEditorView(image: convertedImageFromPDF) { editedImage in
                    let pdfDocument = convertService.convertImageToPDF(with: editedImage, using: url)
                    filesService.rewrite(editedDocument: pdfDocument, to: url)
                    isEditorSharePresent.toggle()
                }
                Spacer()
                
                .sheet(isPresented: $isEditorSharePresent) {
                    let activityItems = [NSURL(fileURLWithPath: url.relativePath)]
                    ShareActivityViewController(activityItems: activityItems).edgesIgnoringSafeArea(.all)
                }
            }
            else {
                PDFWrapperView(url)
                Spacer()
                
                Button {
                    isEditPDF = true
                } label: {
                    Text(Constants.Titles.Buttons.edit)
                }
            }
        }
    }

}
