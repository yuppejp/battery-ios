//
//  AppIconView.swift
//  Battery
//  
//  Created on 2022/09/21
//  

import SwiftUI

struct AppIconView: View {
    private let symbolWidth = 0.055

    var body: some View {
        HStack {
            if #available(iOS 16.0, *) {
                GeometryReader{ geometry in
                    ZStack {
                        Rectangle()
                            .fill(.blue.gradient)

                        ZStack {
                            Circle()
                                .trim(from: 0.15, to: 1 - 0.15)
                                .stroke(
                                    style: StrokeStyle(
                                        lineWidth: 18.0,
                                        lineCap: .square,
                                        lineJoin: .round
                                    )
                                )
                                .rotationEffect(.degrees(90.0))
                                .foregroundColor(.white)

                            Image(systemName: "bolt.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: geometry.size.height / 4)
                                .offset(y: -5)
                            
                            VStack {
                                Image(systemName: "battery.100")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: geometry.size.height / 2.7)
                            }
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .offset(y: 15)
                        }
                        .padding(50)
                    }
                }
            } else {
                Rectangle()
                    .fill(.green)
                    .frame(width:120, height:120)
            }
        }
        .frame(width: 300, height: 300)
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconView()
    }
}
