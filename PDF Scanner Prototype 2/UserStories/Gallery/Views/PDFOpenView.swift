//
//  PDFOpenView.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import SwiftUI
import PDFKit

struct PDFOpenView: View {
    
    // MARK: Properties
    
    var url : URL
    var fileName : String
    
    @Binding
    var PDFview : Bool
    
    @State
    private var share = false
    @State
    private var printPDF = false
    @State
    private var pdfShare = PDFView()
    @State
    private var fileToShare = [Any]()
    
    // MARK: Layout
    
    var body: some View{
        VStack {
            HStack(alignment: .bottom) {
                Button(Constants.Titles.Buttons.back) {
                    withAnimation {
                        PDFview = false
                    }
                }
                
                Spacer()
                Text(fileName).fontWeight(.semibold)
                Spacer()
                
                Button {
                    withAnimation {
                        fileToShare.removeAll()
                        pdfShare.document = PDFDocument(url: url)
                        fileToShare.append(NSURL(fileURLWithPath: url.absoluteString))
                        print(fileToShare.description)
                        share.toggle()
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up").font(.title3)
                }
                
                .sheet(isPresented: $share) {
                    let activityItems = [NSURL(fileURLWithPath: url.relativePath)]
                    ShareActivityViewController(activityItems: activityItems).edgesIgnoringSafeArea(.all)
                }
            }
            .padding()
            
            PDFKitRepresentedView(url)
            Spacer()

            Button {
                printPDF = true
            } label: {
                Text(Constants.Titles.Buttons.print)
            }
        }
    }

}
