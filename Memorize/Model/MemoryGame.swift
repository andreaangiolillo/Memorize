//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Andrea on 09/06/2024.
//

import Foundation

struct MemoryGame <CardContent> where CardContent:Equatable{
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            let id = Int.random(in: 0..<10000)
            cards.append(Card( content: content, id: "\(id)a"))
            cards.append(Card( content: content, id: "\(id)b"))
        }
    }
    
    
    mutating func choose (card: Card){
        let cardIndex = findIndex(card)
        
        cards[cardIndex].toggle()
        cards[cardIndex].wasSeen()
    }
    
    mutating func match (card: Card){
        let cardIndex = findIndex(card)
        cards[cardIndex].matched()
    }
    
    func findIndex(_ card: Card) -> Int {
        for index in cards.indices {
            if cards[index].id == card.id{
                return index
            }
        }
        
        return 0
    }
    
    mutating func changeCards(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            let id = Int.random(in: 0..<10000)
            cards.append(Card( content: content, id: "\(id)a"))
            cards.append(Card( content: content, id: "\(id)b"))
        }
    }
    
    mutating func shuffle(){
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable {
        var isFaceUp = false
        var isMatched = false
        var isSeen = false
        let content: CardContent
        
        var id: String
        
        mutating func toggle(){
            isFaceUp.toggle()
        }
        
        mutating func wasSeen(){
            isSeen = true
        }
        
        mutating func matched(){
            isMatched = true
            isFaceUp =  true
            isSeen = true
        }
    }
}
