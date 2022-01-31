//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by shehan karunarathna on 2022-01-31.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var palette : Palette
    @State var emojiToAdd = ""
    var body: some View {
        Form{
            nameSection
            addemojiSection
            removeEmojiSection
        }
        .navigationTitle("Edit \(palette.name)")
        .frame(width: 300, height: 350)
       
    }
    
    var nameSection : some View{
        Section(header: Text("Name")) {
            TextField("Name", text: $palette.name)
        }
    }
    var addemojiSection : some View{
        Section(header: Text("Add Emoji")) {
            TextField("", text: $emojiToAdd)
                .onChange(of: emojiToAdd) { newValue in
                    addEmojies(emojis: newValue)
                    
                }
        }
    }
    
    var removeEmojiSection : some View{
        Section(header:Text("Remove Emoji") ) {
            let emogies = palette.emojis.map{String($0)}
            LazyVGrid(columns:[GridItem(.adaptive(minimum:40))]){
                ForEach(emogies, id:\.self){
                    emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.removeAll(where: {String($0) == emoji})
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
    
    func addEmojies(emojis:String){
        withAnimation {
            palette.emojis = (emojis + palette.emojis)
                .filter{$0.isEmoji}
        }
      
            
    }
    
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        Text("dsdsad")
            .previewLayout(.fixed(width: 300, height: 350))
    }
}
