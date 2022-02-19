//
//  SetGameView.swift
//  assignment4
//
//  Created by Kihun SONG on 2022/02/04.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameModel
    
    @Namespace private var dealingNamespace
    @Namespace private var discardNamespace
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                newGame
            }
            gameBody
            HStack {
                discardPileBody
                Spacer()
                deckBody
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    var newGame: some View {
        Button("New Game") {
            withAnimation(.easeInOut(duration: CardConstants.dealDuration)) {
                game.newGame()
            }
        }
        .font(.title2)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.table, aspectRatio: CardConstants.aspectRatio, content: { card in
            CardView(card: card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .matchedGeometryEffect(id: card.id * 100, in: discardNamespace)
                .padding(4)
                .onTapGesture {
                    withAnimation {
                        game.choose(card)
                    }
                }
        })
    }
    
    var discardPileBody: some View {
        ZStack {
            ForEach(game.discardPile) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id * 100, in: discardNamespace)
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.deck) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onAppear {
            withAnimation(.easeInOut(duration: CardConstants.dealDuration).delay(CardConstants.dealDuration)) {
                game.startingTableCards()
            }
        }
        .onTapGesture {
            if game.table.isEmpty {
                withAnimation(.easeInOut(duration: CardConstants.dealDuration).delay(CardConstants.dealDuration)) {
                    game.startingTableCards()
                }
            } else {
                withAnimation(.easeInOut(duration: CardConstants.dealDuration)) {
                    game.dealThreeMoreCards()
                }
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.pink
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 120
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct Preview: PreviewProvider {
    static var previews: some View {
        let game = SetGameModel()
        return SetGameView(game: game)
    }
}
