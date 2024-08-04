//
//  EmojiMemorizeGame.swift
//  Memorize
//
//  Created by Andrea on 09/06/2024.
//

import Foundation

class EmojiMemoryGame: ObservableObject {

    private static var defaultTheme = Theme(name: "Default", content: ["👻", "🐔", "👰🏻‍♂️", "🐵", "🐉", "🪃","🧞‍♂️", "🐧", "👹", "🐥", "🐘","🧙‍♀️", "🧙🏼‍♂️"], nPairs: 8, color: "blue", icon: "theatermasks.circle")
    
    private static func createMemoryGame(_ theme: Theme = defaultTheme) -> MemoryGame<String> {
        let emoji = theme.content.shuffled()
        return MemoryGame(numberOfPairsOfCards: theme.nPairs){ pairIndex in
            if emoji.indices.contains(pairIndex){
                return  emoji[pairIndex]
            }
            return emoji[Int.random(in: 0..<emoji.count)]
        }
    }
    
    
    private(set) var score = 0
    private var toggledCard: MemoryGame<String>.Card? = nil
    @Published private var selectedTheme = defaultTheme
    @Published private var model = createMemoryGame()
    @Published private var cardCount = 8
    @Published private var themes: [Theme] = [
         Theme(name: "Hallowen", content: ["🎃", "🕷️", "👻", "👽", "👹", "🧙‍♀️", "🧟‍♂️", "🧛🏼‍♂️", "🧌", "🧟‍♀️", "🧙🏼‍♂️", "🕸️", "🦸🏻‍♀️", "🧝🏾‍♀️"], nPairs: 8, color: "orange", icon: "theatermasks.circle"),
         Theme(name: "Christmas", content:["☃️", "⛄️", "🎅🏼", "🧑🏽‍🎄", "❄️", "🌨️", "🎁", "🌟", "🦌", "🍪", "🔔", "🎄", "🍾", "🌠", "🎉"], nPairs: 4, color: "red", icon: "gift.circle"),
         Theme(name: "Sports", content:["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏓", "🏉", "🎳", "🏸", "🏒", "🥏", "🥌", "🤺", "⛷️"], nPairs: 6, color: "black", icon: "basketball.circle"),
         Theme(name: "Animals", content: ["🐩", "🐇", "🐶", "🐱", "🦊", "🐿️", "🐗", "🫎", "🐼", "🐷", "🐨", "🐴"], nPairs: 8, color: "green", icon: "tortoise.circle"),
         Theme(name: "Fantasy", content: ["🧙‍♀️", "🧟‍♂️", "🧛🏼‍♂️", "🧌", "🧟‍♀️", "🧙🏼‍♂️", "🦸🏻‍♀️", "🧝🏾‍♀️", "🧚🏻", "🧞", "🦹🏼‍♂️"], nPairs: 8, color: "purple", icon: "logo.xbox"),
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
    
    
    func updateScoreWithMatch(){
        score += 2
    }
    
    func updateScoreWithMisMatch(){
        score -= 1
    }
    
    func resetScore(){
        score = 0
    }
    
    // MARK: - Intents
    
    func changeTheme(_ theme: Theme){
        if (selectedTheme.id != theme.id){
            selectedTheme = theme
            newCards(cardCount)
        }
        
        shuffle()
    }
    
    func newCards(_ numberOfPairsOfCards: Int) {
        toggledCard = nil
        let emoji = selectedTheme.content
        model.changeCards(numberOfPairsOfCards: numberOfPairsOfCards){ pairIndex in
            if emoji.indices.contains(pairIndex){
                return  emoji[pairIndex]
            }
            return emoji[Int.random(in: 0..<emoji.count)]
        }
    }
    
    
    func adjustCardCount(by offset: Int){
        if (isValidCountAdjustement(by: offset)) {
            cardCount += offset
            newCards(cardCount)
            shuffle()
        }
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card){
        if toggledCard == nil {
            model.choose(card: card)
            toggledCard = card
            return
        }
        
        if isMatch(toggledCard!.id, card.id) {
            updateScoreWithMatch()
            model.match(card: card)
            model.match(card: toggledCard!)
            toggledCard = nil
            return
        }
        
        if card.isSeen {
            updateScoreWithMisMatch()
        }
        
        model.choose(card: toggledCard!)
        model.choose(card: card)
        toggledCard = card
    }
    
    func isMatch(_ idCardOne: String, _ idCardTwo: String) -> Bool {
        return idCardOne != idCardTwo && idCardOne.dropLast() == idCardTwo.dropLast()
    }
    
    func addTheme(name: String, content: Array<String>, color: String, icon: String){
        themes.append(Theme(name: name, content: content, nPairs: 4, color: color, icon: icon))
    }
    
    func setRandomTheme(){
        let size = themes.count
        selectedTheme = themes[Int.random(in: 0..<size)]
        newCards(8)
        shuffle()
    }
}
