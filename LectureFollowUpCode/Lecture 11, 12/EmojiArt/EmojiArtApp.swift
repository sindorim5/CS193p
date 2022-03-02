//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Kihun SONG on 2022/02/11.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    // L12 mark these as @StateObject since they are "sources of truth"
    @StateObject var document = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Default")
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
            // L12 "inject" our PaletteStore ViewModel into our View hierarchy
                .environmentObject(paletteStore)
        }
    }
}
