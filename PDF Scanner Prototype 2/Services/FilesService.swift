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
    func saveToPasteboard(string: String)
    func rewrite(editedDocument: PDFDocument?, to url: URL)

}

final class FileServiceImplementation: FileService {

    // MARK: FileService

    func getDocumentsDirectory() -> [String] {
        let fileManager = FileManager.default
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let urlPath = urls[0].path

        var documentsLocationDescriptios : [String] = []
        tryExtractDocumentLocationsAndFill(&documentsLocationDescriptios, using: fileManager, urlPath)
        
        return documentsLocationDescriptios
    }

    func deleteFileWith(fileName: String) {
        let fileManager = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        let filePath = documentDirectory.appendingFormat("/" + fileName)
        
        tryRemoveFilePath(from: fileManager, with: filePath)
    }

    func saveDocumentWith(images: [UIImage], pdfName: String) {
        var pdfDocument = PDFDocument()
        insertPages(to: &pdfDocument, with: images)
        
        var pdfData = pdfDocument.dataRepresentation()
        tryCreateDocumentURLAndInsert(to: &pdfData, using: pdfName)
    }
    
    func saveToPasteboard(string: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = string
    }

    func rewrite(editedDocument: PDFDocument?, to url: URL) {
        let newPDFView = PDFView()
        newPDFView.document = editedDocument
        newPDFView.document?.write(to: url)
    }

    // MARK: Private

    private func tryExtractDocumentLocationsAndFill(_ documentsLocationDescriptios: inout [String],
                                                    using fileManager: FileManager, _ urlPath: String) {
        do {
            let items = try fileManager.contentsOfDirectory(atPath: urlPath)
            
            for item in items {
                documentsLocationDescriptios.append(item.description)
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    private func tryRemoveFilePath(from fileManager: FileManager, with filePath: String) {
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

}
