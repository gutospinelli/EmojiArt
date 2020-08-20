//
//  EmojiArtDocumentVM.swift
//  EmojiArt
//
//  Created by Augusto Spinelli on 14/08/20.
//  Copyright © 2020 Augusto Spinelli. All rights reserved
//

import SwiftUI

class EmojiArtDocumentVM : ObservableObject {

    static let palette : String = "🍉🍏🍎🍌🍊🌶🍅🥝🥥"
    
    @Published private var emojiArtModel : EmojiArtModel = EmojiArtModel()
    
    @Published private(set) var backgroundImage : UIImage?
    
    var emojis : [EmojiArtModel.Emoji] { emojiArtModel.emojis }
    
    // MARK: - Intent(s)
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArtModel.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
        if let index = emojiArtModel.emojis.firstIndex(matching: emoji) {
            emojiArtModel.emojis[index].x += Int(offset.width)
            emojiArtModel.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojiArtModel.emojis.firstIndex(matching: emoji) {
            emojiArtModel.emojis[index].size = Int((CGFloat(emojiArtModel.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    func setBackGroundURL(_ url : URL?) {
        emojiArtModel.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
//        guard let url = self.emojiArtModel.backgroundURL else { return }
//        fetchImageCancellable?.cancel()
//        fetchImageCancellable = URLSession.shared
//            .dataTaskPublisher(for: url)
//            .map {data, response in UIImage(data: data)}
//            .receive(on: DispatchQueue.main)
//            .replaceError(with: nil)
//            .assign(to: \.backgroundImage, on: self)
        if let url = self.emojiArtModel.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.emojiArtModel.backgroundURL {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                    
                }
            } 
        }
    }
}

extension EmojiArtModel.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}


