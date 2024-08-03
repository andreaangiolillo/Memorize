//
//  Theme.swift
//  Memorize
//
//  Created by Andrea on 03/08/2024.
//

import Foundation

struct Theme: Equatable, Identifiable {
    private(set) var name: String
    private(set) var content: Array<String>
    private(set) var nPairs: Int32
    private(set) var color: String
    private(set) var icon: String
    
    var id: String
    
    init(name: String, content: Array<String>, nPairs: Int32, color: String, icon: String) {
        self.name = name
        self.content = content
        self.nPairs = nPairs
        self.color = color
        self.icon = icon
        self.id = name
    }
}
