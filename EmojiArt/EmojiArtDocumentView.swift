//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Augusto Spinelli on 14/08/20.
//  Copyright © 2020 Augusto Spinelli. All rights reserved
//

import SwiftUI



struct EmojiArtDocumentView: View {
    
    @ObservedObject var document : EmojiArtDocumentVM
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocumentVM.palette.map { String($0) }, id: \.self ) { emoji in
                        Text(emoji)
                            .font(Font.system(size: self.defaultEmojiSize))
                            .onDrag {
                                 NSItemProvider(object: emoji as NSString)
                            }
                            
                    }
                }
            }
            .padding(.horizontal)
            GeometryReader { geometry in
                ZStack {
                    Rectangle().foregroundColor(.yellow).overlay(
                        Group {
                            if self.document.backgroundImage != nil {
                                Image(uiImage: self.document.backgroundImage!)
                            }
                        }
                    )
                        .edgesIgnoringSafeArea([.bottom,.horizontal])
                        .onDrop(of: ["public.image","public.text"], isTargeted: nil) { providers, location in
                            var location = geometry.convert(location, from: .global)
                            location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                            return self.drop(providers: providers, at: location )
                    }
                    ForEach(self.document.emojis) { emoji in
                        Text(emoji.text)
                            .font(self.font(for: emoji))
                            .position(self.position(for: emoji, in: geometry.size))
                    }
                }
            }
        }
        
    }
    
    func font(for emoji: EmojiArtModel.Emoji) -> Font {
        Font.system(size: emoji.fontSize)
    }
    
    func position(for emoji: EmojiArtModel.Emoji, in size: CGSize) -> CGPoint {
        CGPoint(x: emoji.location.x + size.width/2, y: emoji.location.y + size.height/2)
    }
    
    func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped \(url)")
            self.document.setBackGroundURL(url)
        }
        if !found {
            found = providers.loadFirstObject(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    private let defaultEmojiSize : CGFloat = 50
}



