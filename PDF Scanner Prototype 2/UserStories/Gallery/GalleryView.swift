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
    internal let convertService: ConvertService
    
    @ObservedObject
    internal var scannerModel: ScannerModel
    
    @State
    internal var files : [String] = []
    @State
    internal var isPDFPreviewPresent = false
    @State
    internal var fileName = ""
    @State
    internal var url = URL(string: "")
    
    // MARK: Layout
    
    internal var body: some View {
        ZStack {
            if !isPDFPreviewPresent {
                gridNavigationView
            }
            else {
                PDFPreviewView(filesService: filesService,
                               convertService: convertService,
                               url: url!,
                               fileName: fileName,
                               isPDFOpenView: $isPDFPreviewPresent)
            }
        }
    }
    
    // MARK: View
    
    private var gridNavigationView: some View {
        NavigationView {
            VStack {
                gridView.onAppear {
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
