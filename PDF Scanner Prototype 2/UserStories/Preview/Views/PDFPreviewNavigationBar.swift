//
//  PDFPreviewNavigationBar.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 18.02.2023.
//

import SwiftUI
import PDFKit

struct PDFPreviewNavigationBar: View {
    
    // MARK: Properties
    
    var url:  URL
    var fileName: String
    
    @Binding
    var isPDFOpenView: Bool
    @Binding
    var isEditPDF: Bool

    @State
    var fileToShare = [Any]()
    @State
    var pdfView = PDFView()
    @State
    var isPreviewSharePresent = false
    
    // MARK: Layout
    
    var body: some View {
        HStack(alignment: .bottom) {
            backButtonView
            
            Spacer()
            Text(fileName).fontWeight(.semibold)
            Spacer()
            
            if !isEditPDF {
                shareButtonView
                    .sheet(isPresented: $isPreviewSharePresent) {
                        let activityItems = [NSURL(fileURLWithPath: url.relativePath)]
                        ShareActivityViewController(activityItems: activityItems).edgesIgnoringSafeArea(.all)
                    }
            }
        }
    }
    
    // MARK: Views
    
    private var backButtonView: some View {
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
    }
    
    private var shareButtonView: some View {
        Button {
            withAnimation {
                fileToShare.removeAll()
                pdfView.document = PDFDocument(url: url)
                fileToShare.append(NSURL(fileURLWithPath: url.absoluteString))
                isPreviewSharePresent.toggle()
            }
        } label: {
            Image(systemName: "square.and.arrow.up").font(.title3)
        }
    }

}
