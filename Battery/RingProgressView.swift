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
                          to: getRingPostion(geometry.size))
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
    
    func getRingPostion(_ size: CGSize) -> CGFloat {
        var pos = min(max(0.001, value), 1.0)
        if withSymbole {
            let maxPos = 1.0 - trimMargin(size)
            pos = min(pos, maxPos)
        }
        return pos
    }
    
    func radius(_ size: CGSize) -> CGFloat {
        return min(size.width, size.height) / 2.0
    }
    
    func trimMargin(_ size: CGSize) -> CGFloat {
        let r = radius(size)
        if r < 40 {
            // lock screen widget
            return 0.05
        } else if r < 100 {
            // home screen  widget
            return 0.03
        } else {
            // main app
            return 0.03
        }
    }
    
    func symbolWidth(_ size: CGSize) -> CGFloat {
        let r = radius(size)
        if r < 40 {
            // lock screen widget
            return r / 2.8
        } else if r < 100 {
            // home screen  widget
            return r / 3.2
        } else {
            // main app
            return r / 3.2
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

struct HalfRingProgressView: View {
    var value: Double
    var lineWidth: CGFloat = 12.0
    var systemName: String = ""
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
                    .trim(from: trimMargin(geometry.size),
                          to: 1.0 - trimMargin(geometry.size))
                    .stroke(lineWidth: lineWidth)
                    .rotationEffect(.degrees(90.0))
                    .foregroundColor(outerRingColor)
                Circle()
                    .trim(from: trimMargin(geometry.size),
                          to: getRingPostion(geometry.size))
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .rotationEffect(.degrees(90.0))
                    .foregroundColor(innerRingColor)
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: symbolWidth(geometry.size), height: symbolWidth(geometry.size))
                    .foregroundColor(.gray)
                    .offset(x: 0, y: symbolOffset(geometry.size))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // workaround for when using GeometryReader
            .padding(.all, lineWidth / 2)
        }
    }
    
    func getRingPostion(_ size: CGSize) -> CGFloat {
        let offset = trimMargin(size)
        var pos = value * (1.0 - trimMargin(size) * 2)
        pos += offset
        pos = max(0.001, pos)
        return pos
    }

    func radius(_ size: CGSize) -> CGFloat {
        return min(size.width, size.height) / 2.0
    }
    
    func trimMargin(_ size: CGSize) -> CGFloat {
        let r = radius(size)
        if r < 40 {
            // lock screen widget
            return 0.15
        } else if r < 100 {
            // home screen  widget
            return 0.12
        } else {
            // main app
            return 0.1
        }
    }
    
    func symbolWidth(_ size: CGSize) -> CGFloat {
        let r = radius(size)
        if r < 40 {
            // lock screen widget
            return r
        } else if r < 100 {
            // home screen  widget
            return r / 1.5
        } else {
            // main app
            return r / 1.5
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
        let value = 0.8
        let symbole1 = "bolt.fill"
        let symbole2 = "battery.100"

        Group {
            VStack {
                RingProgressView(value: value, lineWidth: 12.0, systemName: symbole1)
                RingProgressView(value: value, lineWidth: 6.0, systemName: symbole1)
                    .frame(width: 100, height: 100)
                RingProgressView(value: value, lineWidth: 6.0, systemName: symbole1)
                    .frame(width: 50, height: 50)
            }
            .previewDisplayName("Ring")
            
            VStack {
                HalfRingProgressView(value: value, lineWidth: 12.0, systemName: symbole2)
                HalfRingProgressView(value: value, lineWidth: 6.0, systemName: symbole2)
                    .frame(width: 100, height: 100)
                HalfRingProgressView(value: value, lineWidth: 6.0, systemName: symbole2)
                    .frame(width: 50, height: 50)
            }
            .previewDisplayName("HalfRing")
        }
    }
}

