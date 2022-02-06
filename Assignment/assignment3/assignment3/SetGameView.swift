//
//  InitialSetGameView.swift
//  assignment3
//
//  Created by Kihun SONG on 2022/02/04.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameModel
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button("New Game") {
                    game.newGame()  // Task 11
                }
                .font(.title2)
            }
            AspectVGrid(items: game.table, aspectRatio: 2/3, content: { card in
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            })
            Button("Deal 3 More Cards") {
                game.dealThreeMoreCards()
            }
            .disabled(game.deck.isEmpty)    // Task 10.c
            .font(.title)
        }
        .padding(.horizontal)
    }
}

struct Preview: PreviewProvider {
    static var previews: some View {
        let game = SetGameModel()
        return SetGameView(game: game)
    }
}
