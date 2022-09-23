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
                ZStack {
                    Rectangle()
                        .fill(.green.gradient)
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                        .offset(x: 0, y: -105)
                    Circle()
                        .trim(from: symbolWidth, to: 1.0 - symbolWidth)
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: 15.0,
                                lineCap: .square,
                                lineJoin: .round
                            )
                        )
                        .rotationEffect(.degrees(-90.0))
                        .foregroundColor(.white)
                        .padding(45)
                    Image(systemName: "iphone")
                        .resizable()
                        //.renderingMode(.original)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .padding(90)
                        //.imageScale(.large)
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
