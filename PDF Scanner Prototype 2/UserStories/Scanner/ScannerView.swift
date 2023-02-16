//
//  ScannerView.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import SwiftUI
import VisionKit
import PDFKit
import UIKit

struct scanView: View{
    
    // MARK: Properties
    
    internal let filesService: FileService

    @Binding
    var files : [String]
    @ObservedObject
    var scannerModel: ScannerModel
    @Environment(\.presentationMode)
    var mode
    
    @State
    var pdfName = ""
    @State
    var addDoc = false

    // MARK: Layout
    
    var body: some View{
        ZStack{
            VStack{
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
                                    UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController?.present(ac, animated: true)
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
                    Button(action: {
                        withAnimation{
                            addDoc = true
                        }
                    }, label: {
                        VStack{
                            Image(systemName: "plus").font(.largeTitle)
                            Text(Constants.Titles.Buttons.scan)
                        }
                    })
                }
            }.navigationBarItems( trailing: Button(action:{
                guard pdfName.count > 0 else{
                    return
                }
                self.mode.wrappedValue.dismiss()
                filesService.saveDocumentWith(images: scannerModel.imageArray, pdfName: pdfName)
                scannerModel.imageArray.removeAll()
                files = filesService.getDocumentsDirectory()
            }){
                Text(Constants.Titles.Buttons.save)
            })
            if(addDoc){
                VStack{
                    Spacer()
                    VStack{
                        Text(Constants.Titles.Scanner.AddDocument.title).font(.largeTitle)
                        TextField(Constants.Titles.Scanner.AddDocument.TextField.placeHolder, text: $pdfName).multilineTextAlignment(.center)
                        Button(action: {
                            guard pdfName.count > 0 else{
                                return
                            }
                            UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController?.present(scannerModel.getDocumentCameraViewController(), animated: true, completion: nil)
                            addDoc = false
                        }){
                            Text(Constants.Titles.Buttons.next).foregroundColor(.white)
                        }
                    }.padding().background(Color.blue).padding().ignoresSafeArea()
                }
            }
        }
    }
}