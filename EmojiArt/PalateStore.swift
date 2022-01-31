//
//  PalateStore.swift
//  EmojiArt
//
//  Created by shehan karunarathna on 2022-01-31.
//

import Foundation

struct Palette: Identifiable ,Codable, Hashable{
    var name :String
    var emojis :String
    var id :Int
    
    fileprivate init(name:String, emojis:String, id:Int){
        self.name = name
        self.emojis = emojis
        self.id = id
    }
}

class PaletteStore :ObservableObject{
    let name :String
    var userDefaultKey : String{
        "PalatteStore:" + name
    }
    
    @Published var palettes = [Palette]() {
        didSet{
            storeUserDefaults()
        }
    }
    
    func storeUserDefaults(){
        UserDefaults.standard.set(try? JSONEncoder().encode(palettes), forKey: userDefaultKey)
//        UserDefaults.standard.set(palettes.map{[$0.name,$0.emojis,String($0.id)]}, forKey: userDefaultKey)
    }
    
    func restoreUserDefaults(){
        
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultKey),
        
        let decodedata = try? JSONDecoder().decode(Array<Palette>.self, from: jsonData){
            palettes = decodedata
        }
        
//        if let dataArray = UserDefaults.standard.array(forKey: userDefaultKey) as? [[String]]{
//            for item in dataArray{
//                if item.count == 3 , let id = Int(item [2]),!palettes.contains(where: {$0.id == id}){
//                    let pallete = Palette(name: item[0], emojis: item[1], id: id)
//                    palettes.append(pallete )
//                }
//            }
//        }
    }
    
    init(name:String) {
        self.name = name
        restoreUserDefaults()
        if palettes.isEmpty {
            insertPalette(named: "Vehicles",emojis: "🚗🚕🚙🚌🚎🏎🚓")
            insertPalette(named: "Sports",emojis: "⚽️🏀⚾️🎾🏸")
        }
    }
    
    func palette(at index:Int) -> Palette{
        let safeIndex = min(max(index,0),palettes.count - 1)
        return palettes[safeIndex]
    }
    
    @discardableResult
    func removePalette(at index:Int) ->Int{
        if palettes.count > 1, palettes.indices.contains(index){
            palettes.remove(at: index)
        }
        return index % palettes.count
    }
    
    func insertPalette(named name:String, emojis:String? = nil , at index: Int = 0){
        let unique = (palettes.max(by: { p1, p2 in
            p1.id < p2.id
        })?.id ?? 0) + 1
        let palatte = Palette(name:name, emojis: emojis ?? "", id: unique)
        let safeIndex = min(max(index,0), palettes.count)
        palettes.insert(palatte, at: safeIndex)
        
    }
}
