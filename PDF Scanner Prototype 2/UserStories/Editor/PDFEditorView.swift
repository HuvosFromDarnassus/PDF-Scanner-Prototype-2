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

    var image: UIImage

    let onSave: (UIImage) -> Void

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
            saveButton
            editablePDFImage
        }
    }
    
    // MARK: Views
    
    private var editablePDFImage: some View {
        Image(uiImage: self.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .edgesIgnoringSafeArea(.all)
            .overlay(PDFEditCanvasView(onSaved: onChanged,
                                       canvasView: $canvasView),
                     alignment: .bottomLeading)
    }
    
    private var saveButton: some View {
        Button {
            save()
        } label: {
            Text(Constants.Titles.Buttons.save)
        }
    }
    
    // MARK: Private

    private func onChanged() -> Void {
        self.drawingOnImage = canvasView.drawing.image(
            from: canvasView.bounds, scale: UIScreen.main.scale)
    }

    private func initCanvas() -> Void {
        self.canvasView = PKCanvasView();
        self.canvasView.isOpaque = false
        self.canvasView.backgroundColor = UIColor.clear
        self.canvasView.becomeFirstResponder()
    }

    private func save() -> Void {
        onSave(self.image.mergeWith(topImage: drawingOnImage))
    }

}
