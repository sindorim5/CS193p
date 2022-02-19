//
//  CardView.swift
//  assignment4
//
//  Created by Kihun SONG on 2022/02/04.
//

import SwiftUI

struct CardView: View {
    let card: Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                VStack {
                    ForEach(0..<card.numberOfSymbol, id: \.self) { _ in
                        symbol.frame(width: geometry.size.width/2, height: geometry.size.height/6)
                    }
                }
                .foregroundColor(cardColor)

                if card.isSelected {
                    shape.foregroundColor(.gray).opacity(DrawingConstants.opacity)
                }
                if let isMatched = card.isMatched {
                    if isMatched == true {
                        withAnimation(.easeInOut(duration: 1)) {
                            shape.foregroundColor(.green).opacity(DrawingConstants.matchedOpacity)
                        }
                    }
                    else if isMatched == false {
                        withAnimation(.easeInOut(duration: 1)) {
                            shape.foregroundColor(.red).opacity(DrawingConstants.matchedOpacity)
                        }
                    }
                }
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    @ViewBuilder
    private var symbol: some View {
        switch card.symbol {
        case .diamond:
            switch card.shading {
            case .solid:
                Diamond()
            case .striped:
                Diamond().opacity(DrawingConstants.opacity)
            case .open:
                Diamond().stroke(lineWidth: DrawingConstants.lineWidth)
            }
        case .oval:
            switch card.shading {
            case .solid:
                Capsule()
            case .striped:
                Capsule().opacity(DrawingConstants.opacity)
            case .open:
                Capsule().stroke(lineWidth: DrawingConstants.lineWidth)
            }
        case .rectangle:
            switch card.shading {
            case .solid:
                Rectangle()
            case .striped:
                Rectangle().opacity(DrawingConstants.opacity)
            case .open:
                Rectangle().stroke(lineWidth: DrawingConstants.lineWidth)
            }
        }
    }
    
    private var cardColor: Color {
        switch card.color {
        case .yellow:
            return .yellow
        case .red:
            return .red
        case .purple:
            return .purple
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
        static let opacity: CGFloat = 0.3
        static let matchedOpacity: CGFloat = 0.6
    }
}
