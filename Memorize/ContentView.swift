//
//  ContentView.swift
//  Memorize
//
//  Created by Andrea on 08/05/2024.
//

import SwiftUI

struct ContentView: View {
    let contents = ["👻", "🕷️", "🦧", "🎃"]
    
    var body: some View {
        HStack{
            ForEach(contents.indices, id: \.self) { index in
                CardView(content: contents[index])
            }
        }
        .padding().foregroundColor(.orange)
    }
}

struct CardView: View {
    @State var isFaceUp = false
    let content : String
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .continuous)
            if isFaceUp{
                base.strokeBorder(lineWidth: 2).foregroundColor(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            } else {
                base.fill()
            }
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}











#Preview {
    ContentView()
}
