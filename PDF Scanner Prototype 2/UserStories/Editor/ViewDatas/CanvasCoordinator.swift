//
//  CanvasCoordinator.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 18.02.2023.
//

import SwiftUI
import PencilKit

class CanvasCoordinator: NSObject {
    
    // MARK: Properties

    var canvasView: Binding<PKCanvasView>
    let onSaved: () -> Void

    // MARK: Initializers
    
    init(canvasView: Binding<PKCanvasView>, onSaved: @escaping () -> Void) {
        self.canvasView = canvasView
        self.onSaved = onSaved
    }

}

// MARK: - PKCanvasViewDelegate

extension CanvasCoordinator: PKCanvasViewDelegate {

    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        guard !canvasView.drawing.bounds.isEmpty else {
            return
        }
        onSaved()
    }

}
