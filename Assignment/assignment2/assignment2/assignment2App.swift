//
//  assignment2App.swift
//  assignment2
//
//  Created by Kihun SONG on 2022/01/24.
//

import SwiftUI

@main
struct assignment2App: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
