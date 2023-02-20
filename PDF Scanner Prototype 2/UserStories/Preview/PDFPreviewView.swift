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
    internal let extractService: ExtractService
    
    var url: URL
    var fileName: String
    
    @Binding var isPreviewOpen: Bool
    
    @State private var isEditorSharePresent: Bool = false
    @State private var isEditorPresent: Bool = false
    @State private var isExportViewPresent: Bool = false

    @State private var pdfView = PDFView()
    
    @State private var extractedText: String = ""
    
    // MARK: Layout
    
    var body: some View {
        VStack {
            PDFPreviewNavigationBar(url: url,
                                    fileName: fileName,
                                    isPreviewOpen: $isPreviewOpen,
                                    isEditorPresent: $isEditorPresent,
                                    isExportPresent: $isExportViewPresent)
            .padding()
            
            Spacer()
            
            if isEditorPresent, let convertedImageFromPDF = convertService.convertPDFToImage(with: url) {
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
            else if isExportViewPresent {
                ExportView(filesService: filesService, fileName: fileName, text: extractedText)
                Spacer()
            }
            else {
                PDFWrapperView(url)
                Spacer()
                bottomButtonsView
                    .padding()
            }
        }
    }
    
    // MARK: Views
    
    private var bottomButtonsView: some View {
        HStack(spacing: 30) {
            Button {
                extractTextFromDocument()
            } label: { Text(Constants.Titles.Buttons.extractText) }

            Button {
                withAnimation {
                    isEditorPresent.toggle()
                }
            } label: { Text(Constants.Titles.Buttons.edit) }
        }
    }
    
    // MARK: Private
    
    private func extractTextFromDocument() {
        let convertedImageFromPDF = convertService.convertPDFToImage(with: url)
        let extractedText = extractService.extractText(from: convertedImageFromPDF)

        self.extractedText = extractedText

        withAnimation {
            isExportViewPresent.toggle()
        }
    }

}
