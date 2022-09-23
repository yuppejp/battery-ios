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
    var systemName: String = ""
    var withSymbole: Bool {
        return !(systemName == "")
    }
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
        GeometryReader{ geometry  in
            ZStack {
                Circle()
                    .trim(from: withSymbole ? trimMargin(geometry.size) : 0,
                          to: withSymbole ? (1.0 - trimMargin(geometry.size)) : 1.0)
                    .stroke(lineWidth: lineWidth)
                    .rotationEffect(.degrees(-90.0))
                    .foregroundColor(outerRingColor)
                //                    .background(GeometryReader{ geometry -> Text in
                //                        DispatchQueue.main.async {
                //                            circleSize = geometry.size
                //                        }
                //                        return Text("")
                //                    })
                Circle()
                    .trim(from: withSymbole ? trimMargin(geometry.size) : 0,
                          to: withSymbole ? (1.0 - trimMargin(geometry.size)) : min(max(0.001, value), 1.0))
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .rotationEffect(.degrees(-90.0))
                    .foregroundColor(innerRingColor)
                
                if withSymbole {
                    Image(systemName: systemName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: symbolWidth(geometry.size), height: symbolWidth(geometry.size))
                        .foregroundColor(innerRingColor)
                        .offset(x: 0, y: -symbolOffset(geometry.size))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // workaround for when using GeometryReader
            .padding(.all, lineWidth / 2)
        }
    }
    
    func radius(_ size: CGSize) -> CGFloat {
        return min(size.width, size.height) / 2.0
    }
    
    func trimMargin(_ size: CGSize) -> CGFloat {
        let r = radius(size)
        print("**** r: ", r)
        if r < 100 {
            return 0.05
        } else {
            return 0.035
        }
    }
    
    func symbolWidth(_ size: CGSize) -> CGFloat {
        let r = radius(size)
        if r < 40 {
            return r / 2.8
        } else if r < 100 {
            return r / 2.2
        } else {
            return r / 2.5
        }
    }
    
    func symbolOffset(_ size: CGSize) -> CGFloat {
        let r = radius(size)
        var offset = r - (lineWidth / 2)
        if r < 40 {
            offset -= 2
        }
        return offset
    }
}

struct RingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RingProgressView(value: 0.8, lineWidth: 12.0, systemName: "bolt.fill")

            RingProgressView(value: 0.8, lineWidth: 6.0, systemName: "bolt.fill")
                .frame(width: 50, height: 50)
        }
    }
}

