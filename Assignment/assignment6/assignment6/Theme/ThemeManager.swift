//
//  ThemeManager.swift
//  assignment6
//
//  Created by Kihun SONG on 2022/03/01.
//

import SwiftUI

struct ThemeManager: View {
    @EnvironmentObject var store: ThemeStore
    @Environment(\.presentationMode) var presentationMode
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes.filter { $0.emojis.count > 1 }) { theme in
                    NavigationLink(destination: newEmojiMemoryGame(theme)) {
                        VStack(alignment: .leading) {
                            themeView(theme)
                        }
                    }
                    .gesture(editMode == .active ? tapToEditTheme(theme) : nil)
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .listStyle(.inset)
            .navigationTitle("Memorize")
            .sheet(item: $themeToEdit) { theme in
                ThemeEditor(theme: $store.themes[theme])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { addButton }
                ToolbarItem { EditButton() }
            }
            .environment(\.editMode, $editMode)
        }
        .stackNavigationViewStyleOnIpad()
    }
    
    private func newEmojiMemoryGame(_ theme: Theme) -> some View {
        return EmojiMemoryGameView(game: EmojiMemoryGame(theme: theme))
    }
    
    private func themeView(_ theme: Theme) -> some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .foregroundColor(Color(rgbaColor: theme.color))
                .font(.largeTitle)
            Spacer()
            Text(emojiLine(theme)).lineLimit(1)
        }
    }
    
    private func emojiLine(_ theme: Theme) -> String {
        if theme.numberOfPairsOfCards == theme.emojis.count {
            return String("All of \(theme.emojis)")
        } else {
            return String("\(String(theme.numberOfPairsOfCards)) pairs from \(theme.emojis)")
        }
    }
    
    @State private var themeToEdit: Theme?
    
    private func tapToEditTheme(_ theme: Theme) -> some Gesture {
        TapGesture().onEnded {
                themeToEdit = store.themes[theme]
        }
    }
        
    private var addButton: some View {
        Button {
            store.insertTheme(named: "New Theme", at: 0)
            themeToEdit = store.themes.first
        } label: {
            Image(systemName: "plus")
        }
    }
}

struct ThemeManager_Previews: PreviewProvider {
    static var previews: some View {
        ThemeManager().environmentObject(ThemeStore(named: "Preview"))
    }
}
