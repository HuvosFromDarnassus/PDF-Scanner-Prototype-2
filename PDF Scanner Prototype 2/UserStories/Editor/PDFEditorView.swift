//
//  PDFEditorView.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 18.02.2023.
//

import SwiftUI
import PencilKit

struct PDFEditorView: View {
    
    // MARK: Properties
    
    private var image: UIImage
    private let onSave: (UIImage) -> Void
    
    @State private var drawingOnImage: UIImage = UIImage()
    @State private var canvasView: PKCanvasView = PKCanvasView()
    
    // MARK: Initializers
    
    init(image: UIImage, onSave: @escaping (UIImage) -> Void) {
        self.image = image
        self.onSave = onSave
    }
    
    // MARK: Layout
    
    var body: some View {
        VStack {
            saveButtonView
            editablePDFImageView
        }
    }
    
    // MARK: Views
    
    private var editablePDFImageView: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .edgesIgnoringSafeArea(.all)
            .overlay(PDFEditCanvasView(onSaved: onChanged,
                                       canvasView: $canvasView),
                     alignment: .bottomLeading)
    }
    
    private var saveButtonView: some View {
        Button {
            save()
        } label: { Text(Constants.Titles.Buttons.save) }
    }
    
    // MARK: Private
    
    private func onChanged() -> Void {
        drawingOnImage = canvasView.drawing.image(
            from: canvasView.bounds, scale: UIScreen.main.scale)
    }
    
    private func initCanvas() -> Void {
        canvasView = PKCanvasView();
        canvasView.isOpaque = false
        canvasView.backgroundColor = UIColor.clear
        canvasView.becomeFirstResponder()
    }
    
    private func save() -> Void {
        onSave(image.mergeWith(topImage: drawingOnImage))
    }
    
}
