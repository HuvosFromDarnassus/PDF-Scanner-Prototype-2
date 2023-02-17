//
//  PDFOpenView.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import SwiftUI
import PDFKit
import PencilKit

struct PDFOpenView: View {
    
    // MARK: Properties
    
    var url:  URL
    var fileName: String
    
    @Binding
    var isPDFOpenView: Bool
    
    @State
    private var isSharePresent = false
    @State
    private var isPrintPDF = false
    @State
    private var isEditPDF = false

    @State
    private var fileToShare = [Any]()
    @State
    private var pdfView = PDFView()
    @State
    var pencilKitImage: PKCanvasView?
    
    // MARK: Layout
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Button(Constants.Titles.Buttons.back) {
                    withAnimation {
                        if isEditPDF {
                            isEditPDF.toggle()
                        }
                        else {
                            isPDFOpenView = false
                        }
                    }
                }
                
                Spacer()
                Text(fileName).fontWeight(.semibold)
                Spacer()
                
                Button {
                    withAnimation {
                        fileToShare.removeAll()
                        pdfView.document = PDFDocument(url: url)
                        fileToShare.append(NSURL(fileURLWithPath: url.absoluteString))
                        print(fileToShare.description)
                        isSharePresent.toggle()
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up").font(.title3)
                }
                
                .sheet(isPresented: $isSharePresent) {
                    let activityItems = [NSURL(fileURLWithPath: url.relativePath)]
                    ShareActivityViewController(activityItems: activityItems).edgesIgnoringSafeArea(.all)
                }
            }
            .padding()
            
            if isEditPDF {
                // TODO: Open PDFEditorView(url) with back button
            }
            else {
                PDFKitRepresentedView(url)
                Spacer()
                
                Button {
                    isEditPDF = true
                } label: {
                    Text("Edit this PDF")
                }
            }
        }
    }

}
