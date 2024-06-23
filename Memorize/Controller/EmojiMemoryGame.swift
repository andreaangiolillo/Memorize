//
//  EmojiMemorizeGame.swift
//  Memorize
//
//  Created by Andrea on 09/06/2024.
//

import Foundation

class EmojiMemoryGame: ObservableObject {
    enum Themes {
        case def
        case halloween
        case christmas
    }
    
    private static let emojis = ["👻", "🐔", "👰🏻‍♂️", "🐵", "🐉", "🪃","🧞‍♂️", "🐧", "👹", "🐥", "🐘","🧙‍♀️", "🧙🏼‍♂️"]
    private static let contents: [Themes: [String]] = [
        .def:  ["👻", "🐔", "👰🏻‍♂️", "🐵", "🐉", "🪃","🧞‍♂️", "🐧", "👹", "🐥", "🐘","🧙‍♀️", "🧙🏼‍♂️"],
        .halloween: ["🎃", "🕷️", "👻", "👽", "👹", "🧙‍♀️", "🧟‍♂️", "🧛🏼‍♂️", "🧌", "🧟‍♀️", "🧙🏼‍♂️", "🕸️", "🦸🏻‍♀️", "🧝🏾‍♀️"],
        .christmas: ["☃️", "⛄️", "🎅🏼", "🧑🏽‍🎄", "❄️", "🌨️", "🎁", "🌟", "🦌", "🍪", "🔔", "🎄", "🍾", "🌠", "🎉"]
    ]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        let emoji = contents[Themes.def]!
        return MemoryGame(numberOfPairsOfCards: 4){ pairIndex in
            if emoji.indices.contains(pairIndex){
                return  emojis[pairIndex]
            }
            return "⁉️"
        }
    }
    
    @Published private var model = createMemoryGame()
    @Published private var selectedTheme = Themes.def
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    func choose(_ card: MemoryGame<String>.Card){
        model.choose(card: card)
    }
    
    var theme: Themes {
        return selectedTheme
    }
    
    func changeTheme(_ theme: Themes){
        selectedTheme = theme
    }
}
