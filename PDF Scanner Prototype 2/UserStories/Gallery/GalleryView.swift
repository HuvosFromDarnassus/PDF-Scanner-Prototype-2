//
//  ContentView.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import SwiftUI
import VisionKit
import PDFKit

struct GalleryView: View {
    
    // MARK: Properties
    
    internal let filesService: FileService
    
    @ObservedObject
    internal var scannerModel: ScannerModel
    
    @State
    internal var files : [String] = []
    @State
    internal var PDFview = false
    @State
    internal var fileName = ""
    @State
    internal var url = URL(string: "")
    
    // MARK: Layout
    
    var body: some View {
        ZStack {
            if PDFview {
                PDFOpenView(url: url!, fileName: fileName, isPDFOpenView: $PDFview)
            }
            else {
                NavigationView {
                    VStack {
                        pdfView.onAppear {
                            withAnimation() {
                                files = filesService.getDocumentsDirectory()
                            }
                        }
                        Spacer()
                    }
                    .navigationBarTitle(Constants.Titles.Gallery.title, displayMode: .large)
                }
            }
        }
    }
    
}
