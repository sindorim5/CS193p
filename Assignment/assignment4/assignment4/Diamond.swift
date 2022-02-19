//
//  Diamond.swift
//  assignment3
//
//  Created by Kihun SONG on 2022/02/04.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let top = CGPoint(x: rect.midX, y: rect.minY)
        let bot = CGPoint(x: rect.midX, y: rect.maxY)
        let left = CGPoint(x: rect.minX, y: rect.midY)
        let right = CGPoint(x: rect.maxX, y: rect.midY)
        
        p.move(to: top)
        p.addLine(to: left)
        p.addLine(to: bot)
        p.addLine(to: right)
        p.addLine(to: top)
        
        return p
    }
}
