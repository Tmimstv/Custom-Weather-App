//
//  WeatherManager.swift
//  Don't rain on me
//
//  Created by Terrence Mims Jr on 6/26/20.
//  Copyright © 2020 Terrence Mims Jr. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ WeatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    //apikey
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c9370cd15a557ad4ae40b4138fdeaad4&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    //fetch weather via city name
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    //fetch weather via coordinates
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees){
         let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String){
        //Create URL
        if let url = URL(string: urlString) {
            //Create URLSession
            let session = URLSession(configuration: .default)
            //Give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //start task
            task.resume()
        }
    }
    //parse the json
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

