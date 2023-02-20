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

    @State private var isExporting: Bool = false
    @State private var isExtractTextSuccessAlertPresent = false
    
    // MARK: Layout
    
    var body: some View {
        ZStack {
            textEditorView
            exportButtonView
        }

        .sheet(isPresented: $isExporting) {
            exportTypesButtonsView
                .frame(height: 100)
                .background(Color(.secondarySystemBackground))
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
                isExtractTextSuccessAlertPresent = true
            } label: { Text(Constants.Titles.Export.Destination.word) }
            
            Divider()
            
            Button {
                filesService.saveToPasteboard(string: text)
                isExtractTextSuccessAlertPresent = true
            } label: { Text(Constants.Titles.Export.Destination.pasteboard) }
            
            .alert(isPresented: $isExtractTextSuccessAlertPresent) {
                Alert(title: Text(Constants.Titles.Alert.Success.title),
                      message: Text("\(Constants.Titles.Alert.Success.Message.textExtract) \(fileName)."),
                      dismissButton: .default(Text(Constants.Titles.Buttons.ok)) {
                    isExporting = false
                })
            }
        }
    }
    
}
