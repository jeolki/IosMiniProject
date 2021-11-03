//
//  WeatherInformation.swift
//  Weather
//
//  Created by Jeonggi Hong on 2021/11/03.
//

import Foundation


/*
 Codable protocol 자신을 변환하거나 외부표현으로 변환할 수 있는 타입
 외부표현이란 JSON과 같은 것을 말합니다.
 Decodable : 자신을 외부표현에서 디코딩 할 수 있는 타입
 Encodable : 자신을 외부표현으로 인코딩 할 수 있는 타입
 JSON 디코딩과 인코딩이 모두 가능하다는 것을 뜻합니다
 WeatherInformaion 형태를 JSON 과 객체로 만들수 있습니다.
 여기서는 Decoding 하겠습니다.
*/
struct WeatherInformation: Codable {
    let weather: [Weather]
    let temp: Temp
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

// Weather JSON 객체안의 속성을 정의하는 구조체
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// main 키의 객체 속성 정의하는 구조체
struct Temp: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    /*
        JSON키와 구조체에 선언된 프로퍼티의 변수와 이름이 다르다.
        이를 해결하기 위한 CodingKey
    */
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
