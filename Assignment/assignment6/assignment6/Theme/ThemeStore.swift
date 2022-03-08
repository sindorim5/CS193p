//
//  ThemeStore.swift
//  assignment6
//
//  Created by Kihun SONG on 2022/02/28.
//

import Foundation
import SwiftUI

struct Theme: Identifiable, Codable, Hashable, Equatable {
    var name: String
    var emojis: String
    var numberOfPairsOfCards: Int
    var color: RGBAColor
    var id: Int
    
    fileprivate init(name: String, emojis: String, numberOfPairsOfCards: Int, color: RGBAColor, id: Int) {
        self.name = name
        self.emojis = emojis
        self.numberOfPairsOfCards = max(2, min(numberOfPairsOfCards, emojis.count))
        self.color = color
        self.id = id
    }
}


class ThemeStore: ObservableObject {
    let name: String
    
    @Published var themes = [Theme]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String {
        "ThemeStore:" + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
            let decodedThemes = try? JSONDecoder().decode(Array<Theme>.self, from: jsonData) {
            themes = decodedThemes
        }
    }
    
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if themes.isEmpty {
            print("using built-in themes")
            insertTheme(named: "Vehicles",
                        emojis: "🚗🚌🚑🚒🚜🚲🛵🏍🚠🚃🚝🚂✈️🛩🛰🚀🛸🚁🛶⛵️🛳🚐🚎🚕",
                        numberOfPairsOfCards: 12,
                        color: Color(rgbaColor: RGBAColor(255, 0, 0, 1)))
            insertTheme(named: "Animals",
                        emojis: "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐵🐔🐧🐤🦉🐺🐗🐴🦄",
                        numberOfPairsOfCards: 10,
                        color: Color(rgbaColor: RGBAColor(255, 165, 0, 1)))
            insertTheme(named: "Foods",
                        emojis: "🍏🍐🍊🍋🍌🍉🍇🍓🍒🍑🥝🍅🍆🌽🍞🧀🧇🥩🍖🌭🍔🍟🍕🍝",
                        numberOfPairsOfCards: 8,
                        color: Color(rgbaColor: RGBAColor(255, 165, 255, 1)))
            insertTheme(named: "Faces",
                        emojis: "😀😆🤣🥲😍😘😎",
                        numberOfPairsOfCards: 3,
                        color: Color(rgbaColor: RGBAColor(0, 255, 0, 1)))
            insertTheme(named: "Sports",
                        emojis: "⚽️🏀🏈🎾🏐🎱🏓🏸🏒🥊",
                        numberOfPairsOfCards: 5,
                        color: Color(rgbaColor: RGBAColor(0, 0, 255, 1)))
            insertTheme(named: "Flags",
                        emojis: "🏳️🏴🏴‍☠️🏁🇬🇷🇿🇦🇳🇱🇳🇵🇳🇴🇰🇷🇩🇰🇩🇪🇷🇺🇯🇵🇺🇸",
                        numberOfPairsOfCards: 6,
                        color: Color(rgbaColor: RGBAColor(128, 0, 128, 1)))
        } else {
            print("successfully loaded themes from UserDefault: \(themes[0].color.blue)")
        }
    }
    
    // MARK: - Intent
    
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    func removeTheme(at index: Int) -> Int {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }
    
    func insertTheme(named name: String, emojis: String? = nil, numberOfPairsOfCards: Int = 2,
                     color: Color = Color(rgbaColor: RGBAColor(128, 128, 128, 1)), at index: Int = 0) {
        let unique = (themes.max(by: { $0.id < $1.id})?.id ?? 0) + 1
        let theme = Theme(name: name, emojis: emojis ?? "",
                          numberOfPairsOfCards: numberOfPairsOfCards,
                          color: RGBAColor(color: color), id: unique)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
}
