//
//  ContentView.swift
//  Memorize
//
//  Created by Andrea on 08/05/2024.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTheme = themes.def
    @State var cardCount = 2
    
    var emojiMemoryController: EmojiMemoryGame
    enum themes {
        case def
        case hallowen
        case christmas
    }
    
    let contents: [themes: [String]] = [
        .def:  ["👻", "🐔", "👰🏻‍♂️", "🐵", "🐉", "🪃","🧞‍♂️", "🐧", "👹", "🐥", "🐘","🧙‍♀️", "🧙🏼‍♂️"],
        .hallowen: ["🎃", "🕷️", "👻", "👽", "👹", "🧙‍♀️", "🧟‍♂️", "🧛🏼‍♂️", "🧌", "🧟‍♀️", "🧙🏼‍♂️", "🕸️", "🦸🏻‍♀️", "🧝🏾‍♀️"],
        .christmas: ["☃️", "⛄️", "🎅🏼", "🧑🏽‍🎄", "❄️", "🌨️", "🎁", "🌟", "🦌", "🍪", "🔔", "🎄", "🍾", "🌠", "🎉"]
    ]
    
   
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
        LazyVGrid (columns: [GridItem(.adaptive(minimum: 79))]) {
            let content = getShuffleCards()
            ForEach(0..<content.count, id: \.self) { index in
                CardView(content: content[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(getColorBasedOnTheme(theme: selectedTheme))
    }
    
    /*
     getShuffleCards returns an array of card's content where
     each element appear two times and order is shuffled.
     */
    func getShuffleCards() -> [String] {
        var shuffledCards: [String] = []
        if let content = contents[selectedTheme] {
            shuffledCards += content.prefix(upTo: cardCount) + content.prefix(upTo: cardCount)
        }
        return shuffledCards.shuffled()
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
                .foregroundColor(getColorBasedOnTheme(theme: selectedTheme))
        })
        .disabled({
            if let theme = contents[selectedTheme] {
                return cardCount + offset < 2 || cardCount + offset > theme.count
            } else {
                return false
            }
        }())
    }
    
    
    func themeAdjuster(theme: themes, symbol: String) -> some View {
        Button(action: {
            selectedTheme = theme
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
                    case.hallowen:
                        return "Hallowen"
                    }
                }()).font(.body)
            }
            .foregroundColor(getColorBasedOnTheme(theme: theme))
        })
    }
    
    func getColorBasedOnTheme(theme: themes) -> Color {
        switch theme {
        case .def:
            return .blue
        case.christmas:
            return .red
        case.hallowen:
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
        return themeAdjuster(theme: themes.def, symbol: "restart.circle")
    }
    
    var hallowenTheme: some View {
        return themeAdjuster(theme: themes.hallowen, symbol: "theatermasks.circle")
    }
    
    var christmasTheme: some View {
        return themeAdjuster(theme: themes.christmas, symbol: "gift.circle")
    }
}

struct CardView: View {
    @State var isFaceUp = false
    let content : String
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .continuous)
            Group {
                base.strokeBorder(lineWidth: 2).foregroundColor(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
