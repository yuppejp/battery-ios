//
//  RingProgressView.swift
//  Battery
//
//  Created on 2022/09/17.
//

import SwiftUI

struct RingProgressView: View {
    var value: Double
    var lineWidth: CGFloat = 12.0
    var monochrome: Bool = false
    var outerRingColor: Color = Color.gray.opacity(0.3)
    var innerRingColor: Color {
        if monochrome {
            return Color.white
        } else {
            if value < 0.1 {
                return Color.red
            } else if value < 0.25 {
                return Color.yellow
            } else {
                return Color.green
            }
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundColor(outerRingColor)
            Circle()
                .trim(from: 0, to: min(max(0.001, value), 1.0))
                .stroke(
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .foregroundColor(innerRingColor)
                .rotationEffect(.degrees(-90.0))
        }
        .padding(.all, lineWidth / 2)
    }
}

struct RingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        RingProgressView(value: 0.8, lineWidth: 8.0)
    }
}

extension Float {
    var percentString: String {
        let f = NumberFormatter()
        f.numberStyle = .percent
        return f.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
