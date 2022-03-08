//
//  ThemeEditor.swift
//  assignment6
//
//  Created by Kihun SONG on 2022/03/02.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                nameSection
                addEmojisSection
                removeEmojiSection
                numberOfPairsSection
                colorPickerSection
            }
            .navigationTitle("Edit \(theme.name)")
            .toolbar {
                ToolbarItem { saveButton }
            }
        }
    }
        
    // MARK: - Name Section
    
    @State private var name: String
    
    private var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $name)
        }
    }
    
    // MARK: - Add Emojis Section
    
    @State private var newEmojis: String
    @State private var emojisToAdd = ""
    
    private var addEmojisSection: some View {
        Section(header: Text("Add Emojis")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emoji in
                    addEmojis(emoji)
                }
        }
    }
    
    private func addEmojis(_ emojis: String) {
        withAnimation {
            newEmojis = (emojis + newEmojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
    
    // MARK: - Remove Emojis Section
    
    private var removeEmojiSection: some View {
        Section(header: HStack {
            Text("Tap to Remove Emoji")
        }) {
            let emojis = newEmojis.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                newEmojis.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
    
    // MARK: - Number Of Pairs Section
    
    @State private var numberOfPairsOfCards: Int

    private var numberOfPairsSection: some View {
        Section(header: Text("Number Of Pairs Of Cards")) {
            Stepper("\(numberOfPairsOfCards) Pairs",
                    value: $numberOfPairsOfCards,
                    in: newEmojis.count < 2 ? 2...2 : 2...newEmojis.count)
                .onChange(of: newEmojis) { _ in
                    numberOfPairsOfCards = max(2, min(numberOfPairsOfCards, newEmojis.count))
                }
        }
    }
    
    // MARK: - Color Picker Section
    
    @State var fgColor: Color
        
    private var colorPickerSection: some View {
        Section(header: Text("Color Picker")) {
            ColorPicker("Select Color", selection: $fgColor)
                .foregroundColor(fgColor)
        }
    }
    
    // MARK: - Save Button
    
    private var saveButton: some View {
        Button("Save") {
            if presentationMode.wrappedValue.isPresented && newEmojis.count >= 2 {
                saveAll()
                presentationMode.wrappedValue.dismiss()
            }
        }
        .disabled(newEmojis.count < 2 ? true : false)
    }
    
    private func saveAll() {
        theme.name = name
        theme.emojis = newEmojis
        theme.numberOfPairsOfCards = numberOfPairsOfCards
        theme.color = RGBAColor(color: fgColor)
    }

    init(theme: Binding<Theme>) {
        self._theme = theme
        self._name = State(initialValue: theme.wrappedValue.name)
        self._newEmojis = State(initialValue: theme.wrappedValue.emojis)
        self._numberOfPairsOfCards = State(initialValue: theme.wrappedValue.numberOfPairsOfCards)
        self._fgColor = State(initialValue: Color(rgbaColor: theme.wrappedValue.color))
    }
    
}

//struct ThemeEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeEditor(theme: .constant(ThemeStore(named: "preview").theme(at: 4)))
//            .previewLayout(.fixed(width: 300, height: 350))    }
//}
