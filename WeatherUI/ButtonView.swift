//
//  ButtonView.swift
//  WeatherUI
//
//  Created by Aleksii Kyryk on 15/08/2021.
//
import SwiftUI
import Foundation

struct ButtonView: View{
    
    var buttonText: String
    var backgroundColor: Color
    var foregroundColor: Color
    
    var body: some View{
        Text(buttonText)
            .frame(width: 280, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .font(.system(size: 20, weight: .bold, design: .default))
            .cornerRadius(10)
    }
}
