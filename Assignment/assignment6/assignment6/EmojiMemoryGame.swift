//
//  EmojiMemoryGame.swift
//  assignment6
//
//  Created by Kihun SONG on 2022/02/28.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    typealias Card = MemoryGame<String>.Card
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.map{ String($0) }.shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { idx in
            emojis[idx]
        }
    }
        
    @Published private var model: MemoryGame<String>
    
    var chosenTheme: Theme
    
    var cards: Array<Card> {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }
    
    init(theme: Theme) {
        chosenTheme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: chosenTheme)
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }

    func newGame() {
        model = EmojiMemoryGame.createMemoryGame(theme: chosenTheme)
    }
}
