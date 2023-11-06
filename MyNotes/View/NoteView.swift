//
//  NoteView.swift
//  MyNotes
//
//  Created by Revarino Putra on 30/10/23.
//

import SwiftUI
import SwiftData

struct NoteView: View {
    var category: String?
    var allCategories: [NoteCategory]
    @Query private var notes: [Note]
    
    @FocusState private var isFocused: Bool
    @Environment(\.modelContext) private var context
    
    init(category: String?, allCategories: [NoteCategory]) {
        self.category = category
        let predicate = #Predicate<Note> {
            return $0.category?.categoryTitle == category
        }
        
        let favouritePredicate = #Predicate<Note> {
            return $0.isFavourite
        }
        
        let finalPredicate = category == "All Notes" ? nil : (category == "Favourites" ? favouritePredicate : predicate)
        _notes = Query(filter: finalPredicate)
        self.allCategories = allCategories
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let width = size.width
            
            let rowCount = max(Int(width / 250), 1)
            
            
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 30), count: rowCount), spacing: 30, content: {
                        ForEach(notes) { note in
                            NavigationLink(destination: DetailView(), label: {
                                NoteCardView(note: note, isKeyboardEnabled: $isFocused)
                            })
                                
                                .contextMenu(ContextMenu(menuItems: {
                                    Button(note.isFavourite ? "Remove from favourites" : "Move to favourites") {
                                        note.isFavourite.toggle()
                                    }
                                    
                                    Menu {
                                        ForEach(allCategories) { category in
                                            Button {
                                                note.category = category
                                            } label: {
                                                HStack(spacing: 5) {
                                                    if category == note.category {
                                                        Image(systemName: "checkmark")
                                                            .font(.caption)
                                                    }
                                                    
                                                    Text(category.categoryTitle)
                                                }
                                            }
                                            
                                        }
                                    } label: {
                                        Text("Category")
                                    }
                                    
                                    Button("Delete") {
                                        context.delete(note)
                                    }
                                }))
                        }
                    })
                    .padding(12)
                }
                .onTapGesture {
                    isFocused = false
                }
            }
        }
    }
}

struct NoteCardView: View {
    @Bindable var note: Note
    var isKeyboardEnabled: FocusState<Bool>.Binding
    var body: some View {
        TextEditor(text: $note.content)
            .focused(isKeyboardEnabled)
            .overlay(alignment: .leading, content: {
                Text("Finish ur notes")
                    .foregroundStyle(.gray)
                    .padding(.leading, 5)
                    .opacity(note.content.isEmpty ? 1 : 0)
                    .allowsHitTesting(false)
            })
            .padding(15)
            .kerning(1.2)
            .scrollContentBackground(.hidden)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150)
            .background(.gray.opacity(0.15), in: .rect(cornerRadius: 12))
    }
}

