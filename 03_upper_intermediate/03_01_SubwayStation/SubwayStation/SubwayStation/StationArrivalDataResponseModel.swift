//
//  StationArrivalDataResponseModel.swift
//  SubwayStation
//
//  Created by Jeonggi Hong on 2021/12/14.
//

import Foundation

struct  StationArrivalDataResponseModel: Decodable {
    
    var realtimeArrivalList: [RealTimeArrival] = []
    
    struct RealTimeArrival: Decodable {
        let line: String // ~행
        let remainTime: String // 도착까지 남은 시간 or 전역 출발
        let currentStation: String // 현재위치
        
        enum CodingKeys: String, CodingKey {
            case line = "trainLineNM"
            case remainTime = "arvlMsg2"
            case currentStation = "arvlMsg3"
        }
    }
}


