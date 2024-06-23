//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Andrea on 08/05/2024.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @State var cardCount = 2
    
    @ObservedObject var emojiMemoryController:EmojiMemoryGame
   
    // body contains the root view shown in the app
    var body: some View {
        VStack{
            cardCountAdjuster
            ScrollView{
                cards
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
        HStack {
            Spacer()
            defaultTheme
            Spacer()
            hallowenTheme
            Spacer()
            christmasTheme
            Spacer()
        }
    }

    
    var cards: some View {
        LazyVGrid (columns: [GridItem(.adaptive(minimum: 79), spacing: 0)] , spacing: 0) {
            ForEach(0..<emojiMemoryController.cards.count, id: \.self) { index in
                CardView(emojiMemoryController.cards[index])
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
            }
        }
        .foregroundColor(getColorBasedOnTheme(theme: emojiMemoryController.theme))
    }
    
    /*
     cardCountAdjuster returns a Button with the symbol passed as input
     that applies the offset to the cardCount. This function is the core logic
     of the add/remove card buttons.
     */
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
            cardCount += offset
            
        }, label: {
            Image(systemName: symbol)
                .foregroundColor(getColorBasedOnTheme(theme: emojiMemoryController.theme))
        })
        .disabled({
                return cardCount + offset < 2 || cardCount + offset > emojiMemoryController.cards.count
        }())
    }
    
    
    func themeAdjuster(theme: EmojiMemoryGame.Themes, symbol: String) -> some View {
        Button(action: {
            emojiMemoryController.changeTheme(theme)
        }, label: {
            VStack{
                Image(systemName: symbol)
                    .imageScale(.large)
                    .font(.largeTitle)
                Text({
                    switch theme {
                    case .def:
                        return "Default"
                    case.christmas:
                        return "Christmas"
                    case.halloween:
                        return "Hallowen"
                    }
                }()).font(.body)
            }
            .foregroundColor(getColorBasedOnTheme(theme: theme))
        })
    }
    
    func getColorBasedOnTheme(theme: EmojiMemoryGame.Themes) -> Color {
        switch theme {
        case .def:
            return .blue
        case.christmas:
            return .red
        case.halloween:
            return .orange
        }
    }
    
    
    var cardRemover: some View {
        return cardCountAdjuster(by: -1, symbol: "rectangle.stack.fill.badge.minus")
    }
    
    var cardAdder: some View {
        return cardCountAdjuster(by: +1, symbol: "rectangle.stack.fill.badge.plus")
    }
    
    var defaultTheme: some View {
        return themeAdjuster(theme: EmojiMemoryGame.Themes.def, symbol: "restart.circle")
    }
    
    var hallowenTheme: some View {
        return themeAdjuster(theme: EmojiMemoryGame.Themes.halloween, symbol: "theatermasks.circle")
    }
    
    var christmasTheme: some View {
        return themeAdjuster(theme: EmojiMemoryGame.Themes.christmas, symbol: "gift.circle")
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

#Preview {
    EmojiMemoryGameView(emojiMemoryController: EmojiMemoryGame())
}
