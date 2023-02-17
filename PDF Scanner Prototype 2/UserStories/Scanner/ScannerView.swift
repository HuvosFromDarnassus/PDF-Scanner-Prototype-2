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
    
    @ObservedObject
    var scannerModel: ScannerModel

    @Binding
    var files : [String]
    @Environment(\.presentationMode)
    var mode
    
    @State
    var pdfName = ""
    @State
    var addDoc = false

    // MARK: Layout
    
    var body: some View {
        ZStack {
            VStack {
                if let error = scannerModel.errorMessage {
                    Text(error)
                } else {
                    ForEach(scannerModel.imageArray, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit).contextMenu {
                                Button {
                                    let items = [image]
                                    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                                    let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first

                                    window?.rootViewController?.present(ac, animated: true)
                                } label: {
                                    Label(Constants.Titles.Buttons.share, systemImage: "square.and.arrow.up")
                                }

                                Divider()

                                Button {
                                    scannerModel.removeImage(image: image)
                                } label: {
                                    Label(Constants.Titles.Buttons.delete, systemImage: "delete.left")
                                }
                            }
                    }
                    
                    Button {
                        withAnimation{
                            addDoc = true
                        }
                    } label: {
                        VStack{
                            Image(systemName: "plus").font(.largeTitle)
                            Text(Constants.Titles.Buttons.scan)
                        }
                    }
                }
            }
            
            .navigationBarItems(trailing: Button {
                guard pdfName.count > 0 else { return }
                self.mode.wrappedValue.dismiss()
                filesService.saveDocumentWith(images: scannerModel.imageArray, pdfName: pdfName)
                scannerModel.imageArray.removeAll()
                files = filesService.getDocumentsDirectory()
            } label: {
                Text(Constants.Titles.Buttons.save)
            })

            if addDoc {
                VStack {
                    Spacer()

                    VStack {
                        Text(Constants.Titles.Scanner.AddDocument.title).font(.largeTitle)
                        TextField(Constants.Titles.Scanner.AddDocument.TextField.placeHolder, text: $pdfName).multilineTextAlignment(.center)

                        Button {
                            guard pdfName.count > 0 else { return }
                            let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
                            let documentCameraVC  = scannerModel.getDocumentCameraViewController()
                            
                            window?.rootViewController?.present(documentCameraVC, animated: true, completion: nil)

                            addDoc = false
                        } label: {
                            Text(Constants.Titles.Buttons.next).foregroundColor(.white)
                        }
                    }

                    .padding().background(Color.blue).padding().ignoresSafeArea()
                }
            }
        }
    }

}
