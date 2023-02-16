//
//  GalleryView+PDFView.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import Foundation
import SwiftUI

extension GalleryView {
    
    var PDFView: some View{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.width/4))], spacing: 20){
            ForEach( files.indices, id: \.self){ file in
                VStack{
                    Image("docs").resizable().aspectRatio(contentMode: .fit)
                    Spacer()
                    Text("\(files[file])").font(.caption).onTapGesture {
                        withAnimation{
                            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                            let documentDirectory = paths[0].appendingPathComponent(files[file])
                            let filePath = documentDirectory
                            url = filePath
                            fileName = files[file]
                            PDFview = true
                        }
                    }
                }.padding().frame(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/3).background(Color.gray).overlay(
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {
                                filesService.deleteFileWith(fileName: files[file])
                                files.remove(at: file)
                            }){
                                Text(Constants.Titles.Buttons.delete)
                            }
                        }
                        Spacer()
                    }
                ).padding(.horizontal)
            }
            VStack{
                Spacer()
                NavigationLink(destination: scanView(filesService: filesService, files: $files, scannerModel: scannerModel)){
                    VStack{
                        Image(systemName: "plus").font(.largeTitle).padding(.bottom)
                        Text(Constants.Titles.Gallery.Cell.newDocument).font(.caption)
                    }
                }
                Spacer()
            }.padding().frame(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/3).background(Color.gray).padding(.horizontal)
        }.padding()
    }
    
}
