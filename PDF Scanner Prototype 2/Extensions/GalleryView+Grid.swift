//
//  GalleryView+Grid.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import Foundation
import SwiftUI

extension GalleryView {
    
    internal var gridView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 4))], spacing: 20) {
            gridLoopView
            addDocumentLinkView
                .padding()
                .frame(width: UIScreen.main.bounds.width / 4,
                       height: UIScreen.main.bounds.width / 3)
                .background(Color(.secondarySystemBackground))
                .padding(.horizontal)
        }
        .padding()
    }
    
    internal var addDocumentLinkView: some View {
        VStack {
            Spacer()

            let scanView = ScanView(filesService: filesService, scannerModel: scannerModel, files: $files)
            NavigationLink(destination: scanView) {
                VStack{
                    Image(systemName: "plus").font(.largeTitle).padding(.bottom)
                    Text(Constants.Titles.Gallery.Cell.newDocument).font(.caption)
                }
            }

            Spacer()
        }
    }
    
}

extension GalleryView {
    
    internal var gridLoopView: some View {
        ForEach( files.indices, id: \.self) { file in
            VStack {
                Image(Constants.Images.Icons.doc).resizable().aspectRatio(contentMode: .fit)
                Spacer()

                Text("\(files[file])").font(.caption).onTapGesture {
                    withAnimation{
                        prepareAndOpenFilePreview(of: files[file])
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .frame(width: UIScreen.main.bounds.width / 4,
                   height: UIScreen.main.bounds.width / 3)

            .overlay(
                VStack {
                    HStack {
                        Spacer()

                        Button {
                            filesService.deleteFileWith(fileName: files[file])
                            files.remove(at: file)
                        } label: { Text(Constants.Titles.Buttons.delete) }
                    }

                    Spacer()
                }
            )
            .padding(.horizontal)
        }
    }
    
    // MARK: Private
    
    private func prepareAndOpenFilePreview(of file: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0].appendingPathComponent(file)
        let filePath = documentDirectory

        url = filePath
        fileName = file
        isPDFPreviewPresent = true
    }
    
}
