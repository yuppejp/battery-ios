//
//  RingProgressView.swift
//  Battery
//
//  Created on 2022/09/17.
//

import SwiftUI

struct RingProgressView: View {
    var value: Float
    var lineWidth: CGFloat = 12.0
    var symboleName: String = ""
    var withSymbole: Bool {
        return !(symboleName == "")
    }
    var monochrome: Bool = false
    var useGreen: Bool = false
    var outerRingColor: Color = Color.gray.opacity(0.3)
    var innerRingColor: Color {
        if monochrome {
            return Color.white
        } else {
            if value <= 0.1 {
                return Color.red
            } else if value <= 0.2 {
                return Color.yellow
            } else {
                if useGreen {
                    return Color.green
                } else {
                    return Color.blue
                }
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
                    Image(systemName: symboleName)
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
            pos = min(pos, Float(maxPos))
        }
        return CGFloat(pos)
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

struct ArcProgressView: View {
    var value: Float
    var lineWidth: CGFloat = 12.0
    var symboleName: String = ""
    var monochrome: Bool = false
    var useGreen: Bool = false
    var outerRingColor: Color = Color.gray.opacity(0.3)
    var innerRingColor: Color {
        if monochrome {
            return Color.white
        } else {
            if value <= 0.1 {
                return Color.red
            } else if value <= 0.2 {
                return Color.yellow
            } else {
                if useGreen {
                    return Color.green
                } else {
                    return Color.blue
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader{ geometry  in
            ZStack {
                Circle()
                    .trim(from: trimMargin(geometry.size),
                          to: 1.0 - trimMargin(geometry.size))
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .square,
                            lineJoin: .round
                        )
                    )
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // workaround for when using GeometryReader
            .padding(.all, lineWidth / 2)
        }
    }
    
    private struct LevelText: View {
        var level: Float
        var size: CGSize
        
        var body: some View {
            Text(getPercent())
                .font(.system(size: getFontSize()))
                //.bold(size.width < 100 ? true : false)
                .offset(y: -(size.height / 20))
        }
        
        func getPercent() -> String {
            if size.height < 100 {
                return level.toPercentString(percentSymbol: "")
            } else {
                return level.toPercentString()
            }
        }
        
        func getFontSize() -> Double {
            if size.height < 100 {
                return size.height / 2.8
            } else {
                return size.height / 4.0
            }
        }
    }
    
    func getRingPostion(_ size: CGSize) -> CGFloat {
        let offset = trimMargin(size)
        var pos = CGFloat(value) * (1.0 - trimMargin(size) * 2.0)
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
            return 0.18
        } else if r < 100 {
            // home screen  widget
            return 0.17
        } else {
            // main app
            return 0.15
        }
    }
    
    func symbolWidth(_ size: CGSize) -> CGFloat {
        let r = radius(size)
        if r < 40 {
            // lock screen widget
            return r / 1
        } else if r < 100 {
            // home screen  widget
            return r / 1.2
        } else {
            // main app
            return r / 1.5
        }
    }
    
    func symbolOffset(_ size: CGSize) -> CGFloat {
        let r = radius(size)
        var offset = r * 0.65
        offset -= (lineWidth)
        offset -= 3
//        if r < 40 {
//            offset -= 2
//        }
        return offset
    }
}

//struct PieChartView: View {
//   var body: some View {
//
//       GeometryReader{ geometry  in
//           Path { path in
//               path.move(to: CGPoint(x: geometry.size.width / 2,
//                                     y: geometry.size.height / 2
//                                    ))
//               path.addArc(center: .init(x: geometry.size.width / 2,
//                                         y: geometry.size.height / 2),
//                           radius: 180,
//                           startAngle: Angle(degrees: 90.0),
//                           endAngle: Angle(degrees: 180),
//                           clockwise: false)
//           }
//           .fill(Color.orange)
//       }
//   }
//}

struct RingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let value:Float = 0.8
        let symbole1 = "bolt.fill"
        let symbole2 = DeviceInfo.getBattrySymbole(Float(value), .charging)

        Group {
            VStack {
                RingProgressView(value: value, lineWidth: 12.0, symboleName: symbole1)
                RingProgressView(value: value, lineWidth: 6.0, symboleName: symbole1)
                    .frame(width: 100, height: 100)
                RingProgressView(value: value, lineWidth: 6.0, symboleName: symbole1)
                    .frame(width: 50, height: 50)
            }
            .previewDisplayName("Ring")
            
            VStack {
                ArcProgressView(value: value, lineWidth: 12.0, symboleName: symbole2)
                ArcProgressView(value: value, lineWidth: 6.0, symboleName: symbole2)
                    .frame(width: 100, height: 100)
                ArcProgressView(value: value, lineWidth: 6.0, symboleName: symbole2)
                    .frame(width: 50, height: 50)
            }
            .previewDisplayName("Arc")
        }
    }
}

