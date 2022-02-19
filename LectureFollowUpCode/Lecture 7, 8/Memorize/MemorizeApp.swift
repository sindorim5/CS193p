//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Kihun SONG on 2022/01/14.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
