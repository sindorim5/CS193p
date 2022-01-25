//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Kihun SONG on 2022/01/19.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    static let emojis: [String] = ["🚗", "🚌", "🚑", "🚒", "🚜", "🚲",
                            "🛵", "🏍", "🚠", "🚃", "🚝", "🚂",
                            "✈️", "🛩", "🛰", "🚀", "🛸", "🚁",
                            "🛶", "⛵️", "🛳", "🚐", "🚎", "🚕"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in emojis[pairIndex] }
    }
        
    @Published private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
