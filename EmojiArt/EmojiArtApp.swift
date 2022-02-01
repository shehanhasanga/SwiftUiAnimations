//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var document = EmojiArtDocument()
   
    @StateObject var palatteStore = PaletteStore(name: "Default")
    
    
    var body: some Scene {
        DocumentGroup(newDocument:{EmojiArtDocument()}) {config in
            EmojiArtDocumentView(document: config.document)
                .environmentObject(palatteStore)
        }
    }
}
