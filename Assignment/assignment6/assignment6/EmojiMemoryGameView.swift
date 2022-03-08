//
//  ContentView.swift
//  assignment6
//
//  Created by Kihun SONG on 2022/02/28.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame

    var body: some View {
        VStack {
            HStack {
                Text("\(game.chosenTheme.name)").font(.largeTitle)
                Spacer()
                Text("score: \(game.score)").font(.largeTitle)
            }
            .padding(.horizontal)
            ScrollView {
                let cardWidth = widthThatBestFits(cardCount: game.cards.count)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: cardWidth))]) {
                    ForEach(game.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                game.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(Color(rgbaColor: game.chosenTheme.color))
            newGameBtn
        }
        .padding(.horizontal)
    }

    var newGameBtn: some View {
        Button(action: {
            game.newGame()
        }, label: {
             Text("New Game").font(.largeTitle)
        })
    }
    func widthThatBestFits(cardCount: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        var number: CGFloat = 5
        if cardCount == 4 {
            number = 3
        }
        else if (cardCount >= 5 && cardCount < 10) {
            number = 4
        }
        else if (cardCount >= 10 && cardCount < 17) {
            number = 5
        }
        else {
            number = 7
        }
        let cardWidth: CGFloat = screenWidth / number
        return cardWidth
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20.0)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            }
            else if card.isMatched {
                shape.opacity(0)
            }
            else {
                shape.fill()
            }
        }
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let game = EmojiMemoryGame(theme: Theme)
//        EmojiMemoryGameView(game: game).preferredColorScheme(.dark).previewInterfaceOrientation(.portrait)
//        EmojiMemoryGameView(game: game).preferredColorScheme(.light)
//    }
//}
