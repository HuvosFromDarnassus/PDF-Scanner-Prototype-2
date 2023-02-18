//
//  GalleryView+Grid.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import Foundation
import SwiftUI

extension GalleryView {
    
    internal var grid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 4))], spacing: 20) {
            gridLoop
            addDocumentLink
                .padding()
                .frame(width: UIScreen.main.bounds.width / 4,
                       height: UIScreen.main.bounds.width / 3)
                .background(Color(.secondarySystemBackground))
                .padding(.horizontal)
        }
        .padding()
    }
    
    internal var addDocumentLink: some View {
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
    
    internal var gridLoop: some View {
        ForEach( files.indices, id: \.self) { file in
            VStack {
                Image(Constants.Images.Icons.doc).resizable().aspectRatio(contentMode: .fit)
                Spacer()

                Text("\(files[file])").font(.caption).onTapGesture {
                    withAnimation{
                        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                        let documentDirectory = paths[0].appendingPathComponent(files[file])
                        let filePath = documentDirectory

                        url = filePath
                        fileName = files[file]
                        isPDFPreviewPresent = true
                    }
                }
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width / 4,
                   height: UIScreen.main.bounds.width / 3)
            .background(Color(.secondarySystemBackground))

            .overlay(
                VStack {
                    HStack {
                        Spacer()

                        Button {
                            filesService.deleteFileWith(fileName: files[file])
                            files.remove(at: file)
                        } label: {
                            Text(Constants.Titles.Buttons.delete)
                        }
                    }

                    Spacer()
                }
            )
            .padding(.horizontal)
        }
    }
    
}
