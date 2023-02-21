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
    func saveToPasteboard(text: String)
    func saveToTXT(text: String, fileName: String) -> URL?
    func rewrite(editedDocument: PDFDocument?, to url: URL)
    
}

final class FileServiceImplementation: FileService {
    
    // MARK: Properties
    
    private let convertService: ConvertService
    
    private let fileManager: FileManager
    
    // MARK: Initializers
    
    init(convertService: ConvertService = ConvertServiceImplementation(),
         fileManager: FileManager = FileManager.default) {
        self.convertService = convertService
        self.fileManager = fileManager
    }
    
    // MARK: FileService
    
    func getDocumentsDirectory() -> [String] {
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let urlPath = urls[0].path
        
        var documentsLocationDescriptios : [String] = []
        tryExtractDocumentLocationsAndFill(&documentsLocationDescriptios, using: urlPath)
        
        return documentsLocationDescriptios
    }
    
    func deleteFileWith(fileName: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        let filePath = documentDirectory.appendingFormat("/" + fileName)
        
        tryRemoveFilePath(filePath)
    }
    
    func saveDocumentWith(images: [UIImage], pdfName: String) {
        var pdfDocument = PDFDocument()
        insertPages(to: &pdfDocument, with: images)
        
        var pdfData = pdfDocument.dataRepresentation()
        tryCreateDocumentURLAndInsert(to: &pdfData, using: pdfName)
    }
    
    func saveToPasteboard(text: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = text
    }
    
    func saveToTXT(text: String, fileName: String) -> URL? {
        guard let documentDirectoryURL = tryToGetDocumentDirectoryURL() else {
            return nil
        }
        let txtFileURL = documentDirectoryURL.appendingPathComponent("\(fileName).txt")
        
        guard tryToWrite(string: text, to: txtFileURL) else {
            return nil
        }
        
        return txtFileURL
    }
    
    func rewrite(editedDocument: PDFDocument?, to url: URL) {
        let newPDFView = PDFView()
        newPDFView.document = editedDocument
        newPDFView.document?.write(to: url)
    }
    
    // MARK: Private
    
    private func tryExtractDocumentLocationsAndFill(_ documentsLocationDescriptios: inout [String],
                                                    using urlPath: String) {
        do {
            let items = try fileManager.contentsOfDirectory(atPath: urlPath)
            items.forEach { documentsLocationDescriptios.append($0.description) }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    private func tryRemoveFilePath(_ filePath: String) {
        do {
            guard fileManager.fileExists(atPath: filePath) else {
                return
            }
            try fileManager.removeItem(atPath: filePath)
        }
        catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    private func insertPages(to pdfDocument: inout PDFDocument, with images: [UIImage]) {
        for (index, image) in images.enumerated() {
            let pdfPage = PDFPage(image: image)
            pdfDocument.insert(pdfPage!, at: index)
        }
    }
    
    private func tryCreateDocumentURLAndInsert(to pdfData: inout Data?, using pdfName: String) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let documentURL = documentDirectory.appendingPathComponent((pdfName + ".pdf"))
        
        do {
            try pdfData?.write(to: documentURL)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    private func tryToGetDocumentDirectoryURL() -> URL? {
        do {
            return try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            assertionFailure(error.localizedDescription)
        }
        
        return nil
    }
    
    private func tryToWrite(string: String, to url: URL) -> Bool {
        do {
            try string.write(to: url, atomically: true, encoding: .utf8)
            return true
        } catch {
            assertionFailure(error.localizedDescription)
        }
        
        return false
    }
    
}
