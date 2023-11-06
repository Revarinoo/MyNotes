//
//  MyNotesApp.swift
//  MyNotes
//
//  Created by Revarino Putra on 30/10/23.
//

import SwiftUI

@main
struct MyNotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 320, minHeight: 400)
        }
        .modelContainer(for: [Note.self, NoteCategory.self])
    }
}
