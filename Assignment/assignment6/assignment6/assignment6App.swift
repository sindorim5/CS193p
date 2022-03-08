//
//  assignment6App.swift
//  assignment6
//
//  Created by Kihun SONG on 2022/02/28.
//

import SwiftUI

@main
struct assignment6App: App {
    @StateObject var themeStore = ThemeStore(named: "Default")
    
    var body: some Scene {
        WindowGroup {
            ThemeManager().environmentObject(themeStore)
        }
    }
}
