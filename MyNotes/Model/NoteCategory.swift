//
//  NoteCategory.swift
//  MyNotes
//
//  Created by Revarino Putra on 30/10/23.
//

import SwiftUI
import SwiftData

@Model
class NoteCategory {
    var categoryTitle: String
    @Relationship(deleteRule: .cascade, inverse: \Note.category)
    var notes: [Note]?
    
    init(categoryTitle: String) {
        self.categoryTitle = categoryTitle
    }
}
