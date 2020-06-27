 //
//  WeatherData.swift
//  Don't rain on me
//
//  Created by Terrence Mims Jr on 6/26/20.
//  Copyright © 2020 Terrence Mims Jr. All rights reserved.
//

import Foundation

 struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
 }
 
 //get the temperature
 struct Main: Codable {
    let temp: Double
 }
 //get the weather ID
 struct Weather: Codable {
    let id: Int
 }
