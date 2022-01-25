//
//  ContentView.swift
//  assignment1
//
//  Created by Kihun SONG on 2022/01/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var emojis: [String]
    // Task 5
    var emojis1 = ["🚲","🚂","🚁","🚜","🚕","🏎","🚑","🚓","🚒","✈️",
                  "🚀","⛵️","🛸","🛶","🚌","🏍","🛺","🚠","🛵","🚗","🚚",
                  "🚇","🛻","🚝"]
    var emojis2 = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨",
                  "🐯","🦁","🐮","🐷","🐸","🐵","🐔","🐧","🐤","🦉","🐺",
                  "🐗","🐴","🦄"]
    var emojis3 = ["🍏","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🍒","🍑",
                  "🥝","🍅","🍆","🌽","🍞","🧀","🧇","🥩","🍖","🌭","🍔",
                  "🍟","🍕","🍝"]
   
    @State var emojiCount = 4

    init() {
        self.emojis = emojis1
    }
    
    var body: some View {
        VStack {
            // Task 3
            Text("Memorize!")
                .font(.largeTitle)
                .fontWeight(.regular)
                .foregroundColor(.black)
                .padding(.horizontal)
            ScrollView {
                let cardWidth = widthThatBestFits(cardCount: emojiCount)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: cardWidth))]) {
                    ForEach(emojis[0..<emojiCount], id: \.self) { emoji in CardView(content: emoji)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
        }
        .foregroundColor(.red)
        .padding()
        Spacer()
        HStack(alignment: .bottom) {
            Spacer()
            vehicles
            Spacer()
            animals
            Spacer()
            food
            Spacer()
        }
        .padding(.horizontal)
    }
    // Task 4
    var vehicles: some View {
        Button(action: {
            // Task 6, Extra 1
            emojis = emojis1.shuffled()
            emojiCount = Int.random(in: 4..<emojis1.count)
         }) {
             // Task 7, 8, 9
             VStack {
                 Image(systemName: "car").font(.largeTitle)
                 Text("Vehicles").font(.caption)
             }
         }
    }
    var animals: some View {
        Button(action: {
            emojis = emojis2.shuffled()
            emojiCount = Int.random(in: 4..<emojis2.count)
         }) {
             VStack {
                 Image(systemName: "hare").font(.title)
                 Text("Animals").font(.caption)
             }
         }
    }
    var food: some View {
        Button(action: {
            emojis = emojis3.shuffled()
            emojiCount = Int.random(in: 4..<emojis3.count)
         }) {
             VStack {
                 Image(systemName: "fork.knife").font(.title)
                 Text("Foods").font(.caption)
             }
         }
    }
    
    // Extra 2
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
    var content: String
    @State var isFaceUp: Bool = true
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        ContentView()
            .preferredColorScheme(.dark)
    }
}

