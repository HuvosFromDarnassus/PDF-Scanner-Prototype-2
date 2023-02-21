//
//  ExportView.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 20.02.2023.
//

import SwiftUI

struct ExportView: View {
    
    // MARK: Properties
    
    internal let filesService: FileService
    
    @State internal var fileName: String
    @State internal var text: String
    
    @State internal var exportingFileURL: URL
    
    @State private var isExporting: Bool = false
    @State private var isSaveToPasteboardAlertPresent: Bool = false
    @State private var isExportingFileSharePresent: Bool = false
    @State private var isAddFileName: Bool = false
    
    // MARK: Layout
    
    var body: some View {
        ZStack {
            VStack {
                Text(Constants.Titles.Export.title)
                    .font(.title2)
                Divider()
                textEditorView
            }
            
            if !isAddFileName {
                exportButtonView
            }
        }
        
        .sheet(isPresented: $isExporting) {
            exportTypesButtonsView
                .frame(height: 100)
                .background(Color(.secondarySystemBackground))
        }
        .sheet(isPresented: $isExportingFileSharePresent) {
            let activityItems = [NSURL(fileURLWithPath: exportingFileURL.relativePath)]
            ShareActivityViewController(activityItems: activityItems).edgesIgnoringSafeArea(.all)
        }
        
        if isAddFileName {
            addFileNameView
        }
    }
    
    // MARK: Views
    
    private var textEditorView: some View {
        VStack {
            TextEditor(text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text(text).opacity(0).padding(.all, 8)
        }
    }
    
    private var exportButtonView: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    isExporting = true
                } label: {
                    Text(Constants.Titles.Buttons.export)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
    
    private var exportTypesButtonsView: some View {
        VStack {
            Button {
                // To Word code
            } label: { Text(Constants.Titles.Export.Destination.word) }
            
            Divider()
            
            Button {
                withAnimation {
                    isExporting = false
                    isAddFileName = true
                }
            } label: { Text(Constants.Titles.Export.Destination.txt) }
            
            Divider()
            
            Button {
                filesService.saveToPasteboard(text: text)
                isSaveToPasteboardAlertPresent = true
            } label: { Text(Constants.Titles.Export.Destination.pasteboard) }
            
                .alert(isPresented: $isSaveToPasteboardAlertPresent) {
                    Alert(title: Text(Constants.Titles.Alert.Success.title),
                          message: Text("\(Constants.Titles.Alert.Success.Message.textExtract) \(fileName)."),
                          dismissButton: .default(Text(Constants.Titles.Buttons.ok)) {
                        isExporting = false
                    })
                }
        }
    }
    
    private var addFileNameView: some View {
        VStack {
            Spacer()
            VStack {
                Text(Constants.Titles.Scanner.AddDocument.title)
                    .font(.title2)
                TextField(Constants.Titles.Scanner.AddDocument.TextField.placeHolder, text: $fileName)
                    .multilineTextAlignment(.center)
                
                addFileNameSubmitButtonView
            }
            
            .padding()
            .background(Color(.secondarySystemBackground))
            .padding()
            .ignoresSafeArea()
        }
    }
    
    private var addFileNameSubmitButtonView: some View {
        Button {
            withAnimation {
                saveToTXT()
            }
        } label: {
            Text(Constants.Titles.Buttons.submit)
        }
    }
    
    // MARK: Private
    
    private func saveToTXT() {
        guard let txtFileURL = filesService.saveToTXT(text: text, fileName: fileName) else {
            return
        }
        exportingFileURL = txtFileURL
        isAddFileName = false
        isExportingFileSharePresent = true
    }
    
}
