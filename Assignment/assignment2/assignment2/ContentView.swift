//
//  ContentView.swift
//  assignment2
//
//  Created by Kihun SONG on 2022/01/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
        VStack {
            HStack {
                // Task 14, 16
                Text("\(viewModel.gameTitle)").font(.largeTitle)
                Spacer()
                Text("score: \(viewModel.score)").font(.largeTitle)
            }
            .padding(.horizontal)
            ScrollView {
                let cardWidth = widthThatBestFits(cardCount: viewModel.cards.count)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: cardWidth))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(viewModel.themeColor)
            newGameBtn
        }
        .padding(.horizontal)
    }
    // Task 10
    var newGameBtn: some View {
        Button(action: {
            viewModel.newGame()
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game).preferredColorScheme(.dark).previewInterfaceOrientation(.portrait)
        ContentView(viewModel: game).preferredColorScheme(.light)
    }
}

