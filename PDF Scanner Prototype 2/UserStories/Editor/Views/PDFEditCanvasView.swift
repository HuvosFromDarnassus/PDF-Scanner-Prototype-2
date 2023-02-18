//
//  PDFEditCanvasView.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 18.02.2023.
//

import SwiftUI
import PencilKit

struct PDFEditCanvasView {
    
    // MARK: Properties

    let onSaved: () -> Void
    
    @Binding var canvasView: PKCanvasView

    @State var toolPicker = PKToolPicker()

    // MARK: Events

    func showToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }

}

// MARK: - UIViewRepresentable

extension PDFEditCanvasView: UIViewRepresentable {

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(.pen, color: .gray, width: 10)
        canvasView.drawingPolicy = .anyInput
        canvasView.delegate = context.coordinator
        canvasView.backgroundColor = .clear
        showToolPicker()

        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}

    func makeCoordinator() -> CanvasCoordinator {
        Coordinator(canvasView: $canvasView, onSaved: onSaved)
    }

}
