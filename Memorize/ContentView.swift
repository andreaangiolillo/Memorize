//
//  ContentView.swift
//  Memorize
//
//  Created by Andrea on 08/05/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack{
            CardView(isFaceUp: true)
            CardView()
        }
        .padding().foregroundColor(.orange)
    }
}

struct CardView :View {
    var isFaceUp: Bool = false
    
    var body: some View {
        ZStack {
            if isFaceUp{
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .continuous)
                    .strokeBorder(lineWidth: 2)
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .continuous)
                    .strokeBorder(lineWidth: 2)
                Text("👻")
                    .font(.largeTitle)
            }else{
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .continuous)
                    .strokeBorder(lineWidth: 2)
            }

        }
    }
}











#Preview {
    ContentView()
}
