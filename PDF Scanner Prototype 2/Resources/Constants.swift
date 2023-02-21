//
//  Constants.swift
//  PDF Scanner Prototype 2
//
//  Created by Daniel Tvorun on 16.02.2023.
//

enum Constants {
    
    enum Titles {
        
        enum Buttons {
            static let delete: String = "Delete"
            static let back: String = "Back"
            static let print: String = "Print"
            static let share: String = "Share"
            static let scan: String = "Scan Document"
            static let save: String = "Save"
            static let next: String = "Next"
            static let edit: String = "Edit"
            static let extractText: String = "Extact text"
            static let ok: String = "OK"
            static let export: String = "Export"
            static let submit: String = "Submit"
        }
        
        enum Alert {
            
            enum Success {
                
                static let title: String = "Done!"
                
                enum Message {
                    static let save: String = "Successfully saved."
                    static let textExtract: String = "📃 Text successfully extracted from "
                }
                
            }
            
            enum DeleteDocument {
                static let title: String = "❌ Delete "
            }
            
        }
        
        enum Gallery {
            
            static let title: String = "🖨️ PDF Scanner"
            
            enum Cell {
                static let newDocument: String = "Add"
            }
        }
        
        enum Scanner {
            enum AddDocument {
                static let title: String = "📄 Please enter a file name"
                
                enum TextField {
                    static let placeHolder: String = "Enter file name"
                }
            }
        }
        
        enum Export {
            static let title: String = "✏️ Edit text"
            
            enum Destination {
                static let word: String = "To word"
                static let txt: String = "To TXT"
                static let pasteboard: String = "To pasteboard"
            }
            
        }
        
    }
    
    enum Images {
        
        enum Icons {
            static let doc: String = "doc-icon"
        }
        
    }
    
}
