//
//  StationResponseModel.swift
//  SubwayStation
//
//  Created by Jeonggi Hong on 2021/12/14.
//

import Foundation

struct StationResponseModel: Decodable {
    
    // 사용을 편하게 하기위해 경로를 단축하기 위해 선언
    var stations: [Station] { searchInfo.row }
    
    private let searchInfo: SearchInfoBySubwayNameServiceModel
    
    enum CodingKeys: String, CodingKey {
        case searchInfo = "SearchInfoBySubwayNameService"
        
    }
    
    struct SearchInfoBySubwayNameServiceModel: Decodable {
        var row: [Station] = []
    }
    
}

struct Station: Decodable {
    let stationName: String
    let lineNumber: String
    
    enum CodingKeys: String, CodingKey {
        case stationName = "STATION_NM"
        case lineNumber = "LINE_NUM"
    }
}
