//
//  Home.swift
//  MyNotes
//
//  Created by Revarino Putra on 30/10/23.
//

import SwiftUI
import SwiftData

struct Home: View {
    @State private var selectedTag: String = "All Notes"
    @Query(animation: .snappy) private var categories: [NoteCategory]
    @State private var addCategory = false
    @State private var categoryTitle = ""
    @State private var requestedCategory: NoteCategory?
    @State private var deleteRequest = false
    @State private var renameRequest = false
    @State private var selectedCategory: NoteCategory?
    
    @Environment(\.modelContext) private var context
    
    @State private var isDark = true
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTag) {
                Text("All Notes")
                    .tag("All Notes")
                    .foregroundStyle(selectedTag == "All Notes" ? Color.primary : .gray)
                
                Text("Favourites")
                    .tag("Favourites")
                    .foregroundStyle(selectedTag == "Favourites" ? Color.primary : .gray)
                
                Section {
                    ForEach(categories) { category in
                        Text(category.categoryTitle)
                            .tag(category.categoryTitle)
                            .foregroundStyle(selectedTag == category.categoryTitle ? Color.primary : .gray)
                        
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Rename") {
                                    categoryTitle = category.categoryTitle
                                    requestedCategory = category
                                    renameRequest = true
                                }
                                Button("Delete") {
                                    categoryTitle = category.categoryTitle
                                    requestedCategory = category
                                    deleteRequest = true
                                }
                            }))
                    }
                } header: {
                    HStack(alignment: .bottom, spacing: 5) {
                        Text("Categories")
                        Button("", systemImage: "plus") {
                            addCategory.toggle()
                        }
                        .tint(.gray)
                        .buttonStyle(.plain)
                    }
                }

            }
        } detail: {
            NoteView(category: selectedTag, allCategories: categories)
        }
        .navigationTitle(selectedTag)
        // Add category alert
        .alert("Add Category", isPresented: $addCategory) {
            TextField("Record Video", text: $categoryTitle)
            Button("Cancel", role: .cancel) {
                categoryTitle = ""
            }
            
            Button("Add") {
                let category = NoteCategory(categoryTitle: categoryTitle)
                context.insert(category)
                categoryTitle = ""
            }
            
            
        }
        
        // Rename category alert
        .alert("Rename Category", isPresented: $renameRequest) {
            TextField("Record Video", text: $categoryTitle)
            Button("Cancel", role: .cancel) {
                categoryTitle = ""
                requestedCategory = nil
            }
            
            Button("Update") {
                if let requestedCategory {
                    requestedCategory.categoryTitle = categoryTitle
                    categoryTitle = ""
                    self.requestedCategory = nil
                }
            }
            
            
        }
        
        // Delete category alert
        .alert("Delete \(categoryTitle) ?", isPresented: $deleteRequest) {
            Button("Cancel", role: .cancel) {
                categoryTitle = ""
                requestedCategory = nil
            }
            
            Button("Delete", role: .destructive) {
                if let requestedCategory {
                    context.delete(requestedCategory)
                    categoryTitle = ""
                    self.requestedCategory = nil
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 10) {
                    Button("", systemImage: "plus") {
                        let note = Note(content: "")
                        note.category = categories.first{ $0.categoryTitle == selectedTag}
                        context.insert(note)
                    }
                    .disabled(self.selectedTag == "Favourites" ? true : false)

                    Button("", systemImage: isDark ? "sun.min" : "moon") {
                        isDark.toggle()
                    }
                    .contentTransition(.symbolEffect(.replace))
                }
            }
        }
        
        .preferredColorScheme(isDark ? .dark : .light)
    }
}

//#Preview {
//    ContentView()
//}
