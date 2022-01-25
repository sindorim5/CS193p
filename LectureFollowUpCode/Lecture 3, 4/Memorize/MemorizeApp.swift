//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Kihun SONG on 2022/01/14.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
