//
//  Note.swift
//  MyNotes
//
//  Created by Revarino Putra on 30/10/23.
//

import SwiftUI
import SwiftData

@Model
class Note {
    var content: String
    var isFavourite = false
    var category: NoteCategory?
    
    init(content: String, category: NoteCategory? = nil) {
        self.content = content
        self.category = category
    }
}
