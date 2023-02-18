//
//  PDF_Scanner_Prototype_2App.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import SwiftUI

@main
struct PDF_Scanner_Prototype_2App: App {
    
    // MARK: Properties
    
    private let filesService: FileService = FileServiceImplementation()
    private let convertService: ConvertService = ConvertServiceImplementation()

    // MARK: Layout
    
    var body: some Scene {
        WindowGroup {
            GalleryView(filesService: filesService,
                        convertService: convertService,
                        scannerModel: ScannerModel())
        }
    }

}
