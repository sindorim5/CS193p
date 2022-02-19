//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Kihun SONG on 2022/02/11.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
