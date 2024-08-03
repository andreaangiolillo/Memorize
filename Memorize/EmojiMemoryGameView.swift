//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Andrea on 08/05/2024.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var emojiMemoryController:EmojiMemoryGame
   
    // body contains the root view shown in the app
    var body: some View {
        VStack{
            cardCountAdjuster
            ScrollView{
                cards
                    .animation(.default, value: emojiMemoryController.cards)
            }
            Spacer()
            themesAdjuster
        }
        .padding()
    }
    
    // cardCountAdjuster represents the view containing the remove/add buttons and title
    var cardCountAdjuster: some View {
        HStack{
            cardRemover
            Spacer()
            Text("Memorize")
                .font(.largeTitle)
                .bold()
            Spacer()
            cardAdder
        }
        .imageScale(.large)
        .font(.largeTitle)
    }
    
    // themesAdjuster contains the themes buttons views.
    var themesAdjuster: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 15) {
                ForEach(emojiMemoryController.availableThemes) { theme in
                    Spacer()
                    themeAdjuster(theme: theme)
                }
            }
        }
    }
    
    func themeAdjuster(theme: Theme) -> some View {
        Button(action: {
            emojiMemoryController.changeTheme(theme)
        }, label: {
            VStack{
                Image(systemName: theme.icon)
                    .imageScale(.large)
                    .font(.largeTitle)
                Text(theme.name).font(.body)
            }
            .foregroundColor(Color(wordName: theme.color))
        })
    }

    
    var cards: some View {
        LazyVGrid (columns: [GridItem(.adaptive(minimum: 79), spacing: 0)] , spacing: 0) {
            ForEach(emojiMemoryController.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        emojiMemoryController.choose(card)
                    }
            }
        }
        .foregroundColor(Color(wordName: emojiMemoryController.theme.color))
    }
    
    /*
     cardCountAdjuster returns a Button with the symbol passed as input
     that applies the offset to the cardCount. This function is the core logic
     of the add/remove card buttons.
     */
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
            if (emojiMemoryController.isValidCountAdjustement(by: offset)) {
                emojiMemoryController.adjustCardCount(by: offset)
            }
        }, label: {
            Image(systemName: symbol)
                .foregroundColor(Color(wordName: 
                    emojiMemoryController.isValidCountAdjustement(by: offset) ?
                    emojiMemoryController.theme.color : "gray"))
        })
        .disabled({
            return !emojiMemoryController.isValidCountAdjustement(by: offset)
        }())
    }
    
    
    var cardRemover: some View {
        return cardCountAdjuster(by: -1, symbol: "rectangle.stack.fill.badge.minus")
    }
    
    var cardAdder: some View {
        return cardCountAdjuster(by: +1, symbol: "rectangle.stack.fill.badge.plus")
    }
    
}

struct CardView: View {
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    var card: MemoryGame<String>.Card
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .continuous)
            Group {
                base.strokeBorder(lineWidth: 2).foregroundColor(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
    }
}

extension Color {
    
    init?(wordName: String) {
        switch wordName {
        case "clear":       self = .clear
        case "black":       self = .black
        case "white":       self = .white
        case "gray":        self = .gray
        case "red":         self = .red
        case "green":       self = .green
        case "blue":        self = .blue
        case "orange":      self = .orange
        case "yellow":      self = .yellow
        case "pink":        self = .pink
        case "purple":      self = .purple
        case "primary":     self = .primary
        case "secondary":   self = .secondary
        default:            return nil
        }
    }
}

#Preview {
    EmojiMemoryGameView(emojiMemoryController: EmojiMemoryGame())
}
