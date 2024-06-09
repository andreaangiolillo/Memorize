//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Andrea on 08/05/2024.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(emojiMemoryController: game)
        }
    }
}
