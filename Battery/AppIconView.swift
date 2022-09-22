//
//  AppIconView.swift
//  Battery
//  
//  Created on 2022/09/21
//  

import SwiftUI

struct AppIconView: View {
    var body: some View {
        HStack {
            if #available(iOS 16.0, *) {
                ZStack {
                    Rectangle()
                        .fill(.green.gradient)
                    Text("⚡︎")
                        .font(.system(size: 100))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .offset(x: 0, y: -105)
                    Circle()
                        .trim(from: 0.06, to: 0.94)
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
