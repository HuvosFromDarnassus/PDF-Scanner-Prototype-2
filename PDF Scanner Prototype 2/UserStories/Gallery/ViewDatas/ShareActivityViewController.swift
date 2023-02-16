//
//  ShareActivityViewController.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

import SwiftUI

struct ShareActivityViewController: UIViewControllerRepresentable {
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareActivityViewController>) {}
    
}
