//
//  EmojiMemoryGame.swift
//  assignment2
//
//  Created by Kihun SONG on 2022/01/24.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    // Task 8, 9
    static var themes: [Theme] = [
        Theme(name: "Vehicles",
              emojis: ["🚗", "🚌", "🚑", "🚒", "🚜", "🚲",
                       "🛵", "🏍", "🚠", "🚃", "🚝", "🚂",
                       "✈️", "🛩", "🛰", "🚀", "🛸", "🚁",
                       "🛶", "⛵️", "🛳", "🚐", "🚎", "🚕"],
              color: .red),
        Theme(name: "Animals",
              emojis: ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨",
                       "🐯","🦁","🐮","🐷","🐸","🐵","🐔","🐧","🐤","🦉","🐺",
                       "🐗","🐴","🦄"],
              numberOfPairsOfCards: 5,
              color: .orange),
        Theme(name: "Foods",
              emojis: ["🍏","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🍒","🍑",
                       "🥝","🍅","🍆","🌽","🍞","🧀","🧇","🥩","🍖","🌭","🍔",
                       "🍟","🍕","🍝"],
              numberOfPairsOfCards: 4,
              color: .yellow),
        Theme(name: "Faces",
              emojis: ["😀","😆","🤣","🥲","😍","😘","😎"],
              numberOfPairsOfCards: 3,
              color: .green),
        Theme(name: "Sports",
              emojis: ["⚽️","🏀","🏈","🎾","🏐","🎱","🏓","🏸","🏒","🥊"],
              color: .blue),
        Theme(name: "Flags",
              emojis: ["🏳️","🏴","🏴‍☠️","🏁","🇬🇷","🇿🇦","🇳🇱","🇳🇵","🇳🇴","🇰🇷",
                       "🇩🇰","🇩🇪","🇷🇺","🇯🇵","🇺🇸"],
              color: .purple)
    ]
    
    init() {
        theme = EmojiMemoryGame.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        // Task 4, 5, 7
        let emojisArray: [String] = theme.emojis.shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards
                                  ?? Int.random(in: 1...emojisArray.count)) {
            pairIndex in emojisArray[pairIndex]
        }
    }
        
    @Published private var model: MemoryGame<String>
    
    private var theme: Theme
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var gameTitle: String {
        return theme.name
    }
    
    var themeColor: Color {
        return theme.color
    }
    
    var score: Int {
        return model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    // Task 11
    func newGame() {
        theme = EmojiMemoryGame.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}
