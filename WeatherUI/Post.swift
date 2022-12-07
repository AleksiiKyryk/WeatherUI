//
//  Post.swift
//  WeatherUI
//
//  Created by Aleksii Kyryk on 15/08/2021.
//

import Foundation

struct Post: Decodable{
    var name: String
    var main: main
    var sys: sys
    var weather: [weather]
}

struct weather: Decodable{
    var main: String
    var description: String
}

struct main: Decodable {
    var temp: Float
    var feelsLike: Float
    var humidity: Int
    
    enum CodingKeys: String, CodingKey{
        case temp = "temp"
        case feelsLike = "feels_like"
        case humidity = "humidity"
    }
}

struct sys: Decodable {
    var country: String
}
