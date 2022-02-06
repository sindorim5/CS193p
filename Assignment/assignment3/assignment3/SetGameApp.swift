//
//  SetgameApp.swift
//  assignment3
//
//  Created by Kihun SONG on 2022/02/04.
//

import SwiftUI

@main
struct SetGameApp: App {
    private let game = SetGameModel()

    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
