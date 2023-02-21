//
//  ScannerView.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import SwiftUI
import UIKit
import VisionKit
import PDFKit

struct ScanView: View {
    
    // MARK: Properties
    
    internal let filesService: FileService
    
    @ObservedObject internal var scannerModel: ScannerModel
    
    @Environment(\.presentationMode) internal var mode
    
    @Binding internal var files: [String]
    
    @State internal var pdfName = ""
    @State internal var isAddNewDocument = false
    
    @State private var isSaveSuccessAlertPresent = false
    
    // MARK: Layout
    
    internal var body: some View {
        ZStack {
            VStack {
                if let error = scannerModel.errorMessage {
                    Text(error)
                } else {
                    scanImagesLoopView
                    addScanButtonView
                }
            }
            .navigationBarItems(trailing: Button {
                saveScannedDocuments()
                isSaveSuccessAlertPresent.toggle()
            } label: { Text(Constants.Titles.Buttons.save) })
            
            .alert(isPresented: $isSaveSuccessAlertPresent) {
                Alert(title: Text(Constants.Titles.Alert.Success.title),
                      message: Text("📄\(pdfName) \(Constants.Titles.Alert.Success.Message.save)"),
                      dismissButton: .default(Text(Constants.Titles.Buttons.ok)))
            }
            
            if isAddNewDocument {
                addDocumentPopupView
            }
        }
    }
    
    // MARK: Views
    
    private var scanImagesLoopView: some View {
        ForEach(scannerModel.imageArray, id: \.self) { image in
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit).contextMenu {
                    Button {
                        let items = [image]
                        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                        let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
                        
                        window?.rootViewController?.present(activityViewController, animated: true)
                    } label: { Label(Constants.Titles.Buttons.share, systemImage: "square.and.arrow.up") }
                    
                    Divider()
                    
                    Button {
                        scannerModel.removeImage(image: image)
                    } label: { Label(Constants.Titles.Buttons.delete, systemImage: "delete.left") }
                }
        }
    }
    
    private var addScanButtonView: some View {
        Button {
            withAnimation {
                isAddNewDocument = true
            }
        } label: {
            VStack {
                Image(systemName: "plus").font(.largeTitle)
                Text(Constants.Titles.Buttons.scan)
            }
        }
    }
    
    private var addDocumentPopupView: some View {
        VStack {
            Spacer()
            VStack {
                Text(Constants.Titles.Scanner.AddDocument.title)
                    .font(.title2)
                TextField(Constants.Titles.Scanner.AddDocument.TextField.placeHolder, text: $pdfName)
                    .multilineTextAlignment(.center)
                
                addDocumentNextButtonView
            }
            
            .padding()
            .background(Color(.secondarySystemBackground))
            .padding()
            .ignoresSafeArea()
        }
    }
    
    private var addDocumentNextButtonView: some View {
        Button {
            guard !pdfName.isEmpty else { return }
            let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
            let documentCameraVC  = scannerModel.getDocumentCameraViewController()
            
            window?.rootViewController?.present(documentCameraVC, animated: true, completion: nil)
            
            isAddNewDocument = false
        } label: { Text(Constants.Titles.Buttons.next) }
    }
    
    // MARK: Private
    
    private func saveScannedDocuments() {
        guard !pdfName.isEmpty else { return }
        
        self.mode.wrappedValue.dismiss()
        filesService.saveDocumentWith(images: scannerModel.imageArray, pdfName: pdfName)
        scannerModel.imageArray.removeAll()
        files = filesService.getDocumentsDirectory()
    }
    
}
