//
//  PalateManager.swift
//  EmojiArt
//
//  Created by shehan karunarathna on 2022-01-31.
//

import SwiftUI

struct PalateManager: View {
    @EnvironmentObject var store:PaletteStore
    
    @Environment(\.presentationMode) var presentationMode
    
//    @EnvironmentObject(.\presentationMode) var presentationMode
    
    @State private var editMode:EditMode = .inactive
    
    
    
    var body: some View {
        NavigationView{
            List{
                ForEach(store.palettes){
                    palatte in
                    NavigationLink( destination:PaletteEditor(palette: $store.palettes[palatte])){
                        
                        VStack(alignment:.leading){
                            Text(palatte.name)
                            Text(palatte.emojis)
                        }
                        .gesture(editMode == .active ? tap: nil)
                        
                    }
                   
                }
                .onDelete { indexSet in
                    store.palettes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, int in
                    store.palettes.move(fromOffsets: indexSet, toOffset: int)
                }
            }
            .navigationTitle("Manage Palates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem{
                    EditButton()
                }
                
                ToolbarItem(placement:.navigationBarLeading){
                    if presentationMode.wrappedValue.isPresented
//                        ,UIDevice.current.userInterfaceIdiom != .pad
                    {
                        Button("Close"){
                            presentationMode.wrappedValue.dismiss()
                        }
                       
                    }
                }
                
            }
            .environment(\.editMode,$editMode)
        }
        
    }
    
    var tap: some Gesture{
        TapGesture().onEnded { _ in
            
        }
    }
}

struct PalateManager_Previews: PreviewProvider {
    static var previews: some View {
        PalateManager()
            .previewDevice("iPhone 12")
            .environmentObject(PaletteStore(name: "default"))
    }
}
