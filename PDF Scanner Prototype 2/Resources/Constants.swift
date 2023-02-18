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
        }
        
        enum Gallery {
            
            static let title: String = "🖨️ PDF Scanner"
            
            enum Cell {
                static let newDocument: String = "Add"
            }
        }
        
        enum Scanner {
            enum AddDocument {
                static let title: String = "📄 Please Enter a Title"
                
                enum TextField {
                    static let placeHolder: String = "Enter Title"
                }
            }
        }

    }
    
    enum Images {
        
        enum Icons {
            static let doc: String = "doc-icon"
        }
        
    }
    
}
