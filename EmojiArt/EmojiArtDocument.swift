//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

class EmojiArtDocument: ObservableObject
{
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            autosave()
            scheduledAutosaved()
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    private var autosavetimer :Timer?
    
    func scheduledAutosaved(){
        autosavetimer?.invalidate()
        autosavetimer = Timer.scheduledTimer(withTimeInterval: Autosave.coalescingInterval, repeats: false) { _ in
            self.autosave()
        }
    }
    
    struct Autosave{
        static let fileName = "Autosaved.emojiart"
        static let coalescingInterval = 5.0
        static var url:URL?{
            let docdirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return docdirectory?.appendingPathComponent(fileName)
        }
    }
    
    func autosave(){
        if let url = Autosave.url{
            save(url: url)
        }
    }
    
    func save(url:URL){
        do {
            let data: Data = try emojiArt.json()
            try data.write(to: url)
        } catch let encodingerror where encodingerror is EncodingError{
            
            print("encoding error occured")
            print(encodingerror)
        }
        catch let error{
            print(error)
        }
      
    }
    
    init() {
        if let url = Autosave.url, let autosaveEmojiart = try? EmojiArtModel(url: url){
            emojiArt = autosaveEmojiart
            fetchBackgroundImageDataIfNecessary()
        } else {
            emojiArt = EmojiArtModel()
        }
//        emojiArt = EmojiArtModel()
//        emojiArt.addEmoji("😀", at: (-200, -100), size: 80)
//        emojiArt.addEmoji("😷", at: (50, 100), size: 40)
    }
    
    var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
    var background: EmojiArtModel.Background { emojiArt.background }
    
    // MARK: - Background
    
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    
    enum BackgroundImageFetchStatus : Equatable{
        case idle
        case fetching
        case failed(URL)
    }
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .url(let url):
            // fetch the url
            backgroundImageFetchStatus = .fetching
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = try? Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
                        self?.backgroundImageFetchStatus = .idle
                        if imageData != nil {
                            self?.backgroundImage = UIImage(data: imageData!)
                        }
                        if self?.backgroundImage == nil {
                            self?.backgroundImageFetchStatus = .failed(url)
                        }
                    }
                }
            }
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }
    
    // MARK: - Intent(s)
    
    func setBackground(_ background: EmojiArtModel.Background) {
        emojiArt.background = background
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
}