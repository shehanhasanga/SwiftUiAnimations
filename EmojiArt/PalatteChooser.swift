//
//  PalatteChooser.swift
//  EmojiArt
//
//  Created by shehan karunarathna on 2022-01-31.
//

import SwiftUI

struct PalatteChooser: View {
    @ScaledMetric var emojiFontSize: CGFloat = 40
    @EnvironmentObject var store:PaletteStore
    let testEmojis = "😀😷🦠💉👻👀🐶🌲🌎🌞🔥🍎⚽️🚗🚓🚲🛩🚁🚀🛸🏠⌚️🎁🗝🔐❤️⛔️❌❓✅⚠️🎶➕➖🏳️"
    @SceneStorage("PalatteChooser.choosenIndex") private var choosenIndex = 0
    var body: some View {
//        let palatte = store.palette(at: choosenIndex)
        HStack{
            palletControlButton
            body(for: store.palette(at: choosenIndex))
        }
        .clipped()
      
        
       
    }
    
    var palletControlButton : some View{
        Button{
            withAnimation {
                choosenIndex = (choosenIndex+1) % store.palettes.count
            }
           
        }label:{
            Image(systemName: "paintpalette")
                .font(.largeTitle)
        }
        .font(.system(size: 50))
        .contextMenu{contextMen}
       
    }
    
    @State var editing = false
    @State var palateToEdit : Palette?
    @State var managing : Bool = false
    
    @ViewBuilder
    var contextMen: some View{
        AnimatedActionButton(title: "Edit", systemImage: "pencil") {
            editing = true
            palateToEdit = store.palette(at: choosenIndex)
        }
        AnimatedActionButton(title: "New", systemImage: "plus") {
            store.insertPalette(named: "New", emojis: "", at: choosenIndex)
            editing = true
        }
        AnimatedActionButton(title: "Delete", systemImage: "minus.circle") {
            store.removePalette(at: choosenIndex)
        }
        AnimatedActionButton(title: "Manager", systemImage: "slider.vertical.3") {
            managing = true
        }
        gotomenu
    }
    
    var gotomenu: some View{
        Menu{
            ForEach (store.palettes){
                palete in
                AnimatedActionButton(title: palete.name) {
                    if let index = store.palettes.firstIndex(where: {$0.id == palete.id}){
                        choosenIndex = index
                    }
                        
                }
            }
        }label:{
            Label("Go To",systemImage: "text.insert")
        }
    }
    func body(for palatte:Palette) -> some View{
        HStack{
            Text(palatte.name)
            ScrollingEmojisView(emojis: palatte.emojis)
                .font(.system(size: emojiFontSize))
        }
        .id(palatte.id)
        .transition(trasition)
//        .popover(isPresented: $editing) {
//            PaletteEditor(palette: $store.palettes[choosenIndex])
//        }
        .popover(item: $palateToEdit) { palatte in
            PaletteEditor(palette: $store.palettes[palatte])
        }
        .sheet(isPresented: $managing) {
            PalateManager()
        }
    }
    
    var trasition : AnyTransition{
        AnyTransition.asymmetric(insertion: .offset(x:0,y:emojiFontSize), removal: .offset(x:0,y:-emojiFontSize))
    }
}
struct ScrollingEmojisView: View {
    let emojis: String

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}

