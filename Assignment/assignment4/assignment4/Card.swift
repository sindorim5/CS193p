//
//  Card.swift
//  assignment4
//
//  Created by Kihun SONG on 2022/02/04.
//

import Foundation
import SwiftUI

struct Card: Identifiable {
    var isFaceUp = false
    var isSelected = false
    var isMatched: Bool?
    var numberOfSymbol: Int
    var symbol: Symbol
    var shading: Shading
    var color: Color
    let id: Int
    
    enum Symbol: CaseIterable {
        case diamond
        case rectangle
        case oval
    }
    enum Shading: CaseIterable {
        case solid
        case striped
        case open
    }
    enum Color: CaseIterable {
        case yellow
        case red
        case purple
    }
}
