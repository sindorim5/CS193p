//
//  InitialSetGame.swift
//  assignment3
//
//  Created by Kihun SONG on 2022/02/04.
//

import SwiftUI

class SetGameModel: ObservableObject {
    
    private static func createSetGame() -> SetGame {
        SetGame()
    }
    
    @Published private var model = createSetGame()
        
    var deck: Array<Card> {
        return model.deck
    }
    var table: Array<Card> {
        return model.table
    }
    func choose(_ card: Card) {
        model.choose(card)
    }
    func dealThreeMoreCards() {
        model.dealThreeMoreCards()
    }
    func newGame() {
        model = SetGameModel.createSetGame()
    }
}
