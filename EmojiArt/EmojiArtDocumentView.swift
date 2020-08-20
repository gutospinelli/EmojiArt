//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Augusto Spinelli on 14/08/20.
//  Copyright © 2020 Augusto Spinelli. All rights reserved.
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
                            
                    }
                }
            }
            .padding(.horizontal)
            Rectangle().foregroundColor(.yellow).overlay(
                Group {
                    if self.document.backgroundImage != nil {
                        Image(uiImage: self.document.backgroundImage!)
                    }
                }
            )
                .edgesIgnoringSafeArea([.bottom,.horizontal])
                .onDrop(of: ["public.image"], isTargeted: nil) { providers, location in
                    return self.drop(providers: providers)
            }
        }
        
    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped \(url)")
            self.document.setBackGroundURL(url)
        }
        return found
    }
    
    private let defaultEmojiSize : CGFloat = 50
}



