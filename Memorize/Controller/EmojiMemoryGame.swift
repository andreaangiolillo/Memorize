//
//  EmojiMemorizeGame.swift
//  Memorize
//
//  Created by Andrea on 09/06/2024.
//

import Foundation

class EmojiMemoryGame: ObservableObject {

    private static var defaultTheme = Theme(name: "Default", content: ["👻", "🐔", "👰🏻‍♂️", "🐵", "🐉", "🪃","🧞‍♂️", "🐧", "👹", "🐥", "🐘","🧙‍♀️", "🧙🏼‍♂️"], nPairs: 4, color: "blue", icon: "theatermasks.circle")
    
    private static func createMemoryGame(_ theme: Theme = defaultTheme) -> MemoryGame<String> {
        let emoji = theme.content.shuffled()
        return MemoryGame(numberOfPairsOfCards: 4){ pairIndex in
            if emoji.indices.contains(pairIndex){
                return  emoji[pairIndex]
            }
            return "⁉️"
        }
    }
    
    @Published private var selectedTheme = defaultTheme
    @Published private var model = createMemoryGame()
    @Published private var cardCount = 4
    @Published private var themes: [Theme] = [
        Theme(name: "Default", content: ["👻", "🐔", "👰🏻‍♂️", "🐵", "🐉", "🪃","🧞‍♂️", "🐧", "👹", "🐥", "🐘","🧙‍♀️", "🧙🏼‍♂️"], nPairs: 4, color: "blue", icon: "theatermasks.circle"),
         Theme(name: "Hallowen", content: ["🎃", "🕷️", "👻", "👽", "👹", "🧙‍♀️", "🧟‍♂️", "🧛🏼‍♂️", "🧌", "🧟‍♀️", "🧙🏼‍♂️", "🕸️", "🦸🏻‍♀️", "🧝🏾‍♀️"], nPairs: 4, color: "orange", icon: "theatermasks.circle"),
         Theme(name: "Christmas", content:["☃️", "⛄️", "🎅🏼", "🧑🏽‍🎄", "❄️", "🌨️", "🎁", "🌟", "🦌", "🍪", "🔔", "🎄", "🍾", "🌠", "🎉"], nPairs: 4, color: "red", icon: "gift.circle")
     ]
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var theme: Theme {
        return selectedTheme
    }
    
    var count: Int {
        return cardCount
    }
    
    var availableThemes: Array<Theme> {
        return themes
    }
    
    func isValidCountAdjustement(by offset: Int) -> Bool{
        return cardCount + offset > 2 && cardCount + offset < selectedTheme.content.count
    }
    
    // MARK: - Intents
    
    func changeTheme(_ theme: Theme){
        if (selectedTheme.id != theme.id){
            selectedTheme = theme
            newCards(cardCount)
        }else{
            shuffle()
        }
    }
    
    func newCards(_ numberOfPairsOfCards: Int) {
        let emoji = selectedTheme.content
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
    
    func choose(_ card: MemoryGame<String>.Card){
        model.choose(card: card)
    }
    
}
