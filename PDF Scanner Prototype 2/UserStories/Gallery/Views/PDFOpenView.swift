//
//  PDFOpenView.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import SwiftUI
import PDFKit

struct PDFOpenView : View{
    
    var url : URL
    var fileName : String
    
    @Binding
    var PDFview : Bool
    
    @State
    var share = false
    @State
    var printPDF = false
    @State
    var pdfShare = PDFView()
    @State
    var fileToShare = [Any]()
    
    var body: some View{
        VStack{
            HStack(alignment: .bottom){
                Button(action: {
                    withAnimation{
                        PDFview = false
                    }
                }){
                    Text(Constants.Titles.Buttons.back).fontWeight(.semibold)
                }
                Spacer()
                Text(fileName).fontWeight(.semibold)
                Spacer()
                Button(action: {
                    withAnimation{
                        fileToShare.removeAll()
                        pdfShare.document = PDFDocument(url: url)
                        fileToShare.append(NSURL(fileURLWithPath: url.absoluteString))
                        print(fileToShare.description)
                        share.toggle()
                    }
                }){
                    Image(systemName: "square.and.arrow.up").font(.title3)
                }.sheet(isPresented: $share, content: {
                    //                    ActivityViewController(activityItems: [pdfShare.document?.dataRepresentation()]).edgesIgnoringSafeArea(.all)
                    ShareActivityViewController(activityItems: [NSURL(fileURLWithPath: url.relativePath)]).edgesIgnoringSafeArea(.all)
                })
            }.padding()
            PDFKitRepresentedView(url)
            Spacer()
            Button(action: {
                printPDF = true
            }){
                Text(Constants.Titles.Buttons.print)
            }
        }
    }
}
