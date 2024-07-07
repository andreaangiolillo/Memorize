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
    
    private static let contents: [Themes: [String]] = [
        .def:  ["👻", "🐔", "👰🏻‍♂️", "🐵", "🐉", "🪃","🧞‍♂️", "🐧", "👹", "🐥", "🐘","🧙‍♀️", "🧙🏼‍♂️"],
        .halloween: ["🎃", "🕷️", "👻", "👽", "👹", "🧙‍♀️", "🧟‍♂️", "🧛🏼‍♂️", "🧌", "🧟‍♀️", "🧙🏼‍♂️", "🕸️", "🦸🏻‍♀️", "🧝🏾‍♀️"],
        .christmas: ["☃️", "⛄️", "🎅🏼", "🧑🏽‍🎄", "❄️", "🌨️", "🎁", "🌟", "🦌", "🍪", "🔔", "🎄", "🍾", "🌠", "🎉"]
    ]
    
    private static func createMemoryGame(_ theme: Themes = .def) -> MemoryGame<String> {
        let emoji = contents[theme]!.shuffled()
        return MemoryGame(numberOfPairsOfCards: 4){ pairIndex in
            if emoji.indices.contains(pairIndex){
                return  emoji[pairIndex]
            }
            return "⁉️"
        }
    }
    
    
    @Published private var model = createMemoryGame()
    @Published private var selectedTheme = Themes.def
    @Published private var cardCount = 4
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    func choose(_ card: MemoryGame<String>.Card){
        model.choose(card: card)
    }
    
    var theme: Themes {
        return selectedTheme
    }
    
    var count: Int {
        return cardCount
    }
    
    func isValidCountAdjustement(by offset: Int) -> Bool{
            return cardCount + offset > 2 && cardCount + offset < EmojiMemoryGame.contents[.def]!.count
    }
    
    // MARK: - Intents
    
    func changeTheme(_ theme: Themes){
        if (selectedTheme != theme){
            selectedTheme = theme
            newCards(cardCount)
        }else{
            shuffle()
        }
    }
    
    func newCards(_ numberOfPairsOfCards: Int) {
        let emoji = EmojiMemoryGame.contents[theme]!
        model.changeCards(numberOfPairsOfCards: numberOfPairsOfCards){ pairIndex in
            if emoji.indices.contains(pairIndex){
                return  emoji[pairIndex]
            }
            return "⁉️"
        }
    }
    
    
    func adjustCardCount(by offset: Int){
        if (isValidCountAdjustement(by: offset)) {
            cardCount += offset
            newCards(cardCount)
        }
    }
    
    func shuffle() {
        model.shuffle()
    }
}
