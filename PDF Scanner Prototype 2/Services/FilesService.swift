//
//  FilesService.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import UIKit
import PDFKit

protocol FileService {
    
    func getDocumentsDirectory() -> [String]
    func deleteFileWith(fileName: String)
    func saveDocumentWith(images: [UIImage], pdfName: String)
    
}

final class FileServiceImplementation: FileService {
    
    
    // MARK: FileService
    
    func getDocumentsDirectory() -> [String] {
        do {
            var a : [String] = []
            let fm = FileManager.default
            let path =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
            print(path)
            let items = try fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                print("Found \(item)")
                a.append(item.description)
            }
            return a
        } catch {
            // failed to read directory – bad permissions, perhaps?
            let a : [String] = []
            return a
        }
    }

    func deleteFileWith(fileName: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        let filePath = documentDirectory.appendingFormat("/" + fileName)
        
        do {
            let fileManager = FileManager.default
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        print("removed")
    }

    func saveDocumentWith(images: [UIImage], pdfName: String) {
        
        do{
            let pdfDocument = PDFDocument()
            
            for i in images.indices{
                let pdfPage = PDFPage(image: images[i])
                pdfDocument.insert(pdfPage!, at: i)
            }
            
            let data = pdfDocument.dataRepresentation()
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let docURL = documentDirectory.appendingPathComponent((pdfName + ".pdf"))
            print(docURL)
            try data?.write(to: docURL)
        }catch(let error){
            print("error is \(error.localizedDescription)")
        }
    }
    
}
