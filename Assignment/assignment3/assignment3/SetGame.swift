//
//  SetGame.swift
//  assignment3
//
//  Created by Kihun SONG on 2022/02/04.
//

import Foundation
import SwiftUI

struct SetGame {
    private(set) var deck: Array<Card>
    private(set) var table: Array<Card>
    
    private var indexOfSelected: Array<Int> {
        get { table.indices.filter{ table[$0].isSelected } }
    }
    
//    They all have the same number or have three different numbers.
//    They all have the same shape or have three different shapes.
//    They all have the same shading or have three different shadings.
//    They all have the same color or have three different colors.
    
    private var isMatched: Bool {
        get {
            if indexOfSelected.count == 3 {
                let card1 = table[indexOfSelected[0]]
                let card2 = table[indexOfSelected[1]]
                let card3 = table[indexOfSelected[2]]
                
                let numberMatch = (card1.numberOfSymbol == card2.numberOfSymbol && card2.numberOfSymbol == card3.numberOfSymbol) ||
                (card1.numberOfSymbol != card2.numberOfSymbol && card2.numberOfSymbol != card3.numberOfSymbol
                 && card3.numberOfSymbol != card1.numberOfSymbol)
                
                let symbolMatch = (card1.symbol == card2.symbol && card2.symbol == card3.symbol) ||
                (card1.symbol != card2.symbol && card2.symbol != card3.symbol && card3.symbol != card1.symbol)
                
                let shadingMatch = (card1.shading == card2.shading && card2.shading == card3.shading) ||
                (card1.shading != card2.shading && card2.shading != card3.shading && card3.shading != card1.shading)
                
                let colorMatch = (card1.color == card2.color && card2.color == card3.color) ||
                (card1.color != card2.color && card2.color != card3.color && card3.color != card1.color)
                
                return numberMatch && symbolMatch && shadingMatch && colorMatch
            }
            else { return false }
        }
    }
    
    mutating func choose(_ card: Card) {
        // Task 8, 9
        if indexOfSelected.count == 3 {
            if isMatched == true {
                replaceTableCards()
            }
            table.indices.forEach {
                table[$0].isSelected = false
                table[$0].isMatched = nil
            }
        }
        
        if let chosenIndex = table.firstIndex(where: {$0.id == card.id}) {
            // Task 7
            table[chosenIndex].isSelected.toggle()
            if indexOfSelected.count == 3 {
                let matchedResult = isMatched
                indexOfSelected.forEach { index in
                    table[index].isMatched = matchedResult
                }
            }
        }
    }
    
    mutating func dealThreeMoreCards() {
        // Task 10
        if indexOfSelected.count == 3 {
            if isMatched == true {
                replaceTableCards()
                return
            }
        }
            if !deck.isEmpty {
                for _ in 0..<3 {
                    table.append(deck.popLast()!)
                }
            }
    }
    
    mutating func replaceTableCards() {
        indexOfSelected.forEach { index in
            table.remove(at: index)
            if !deck.isEmpty {
                table.insert(deck.popLast()!, at: index)
            }
        }
    }
    
    init(){
        deck = []
        table = []
        var id = 0
        for symbol in Card.Symbol.allCases {
            for shading in Card.Shading.allCases {
                for color in Card.Color.allCases {
                    for num in 1...3 {
                        deck.append(Card(numberOfSymbol: num, symbol: symbol, shading: shading, color: color, id: id))
                        id += 1
                    }
                }
            }
        }
        deck.shuffle() //   Task 11
        
        for _ in 1...12 {
            table.append(deck.popLast()!)
        }
    }
}
