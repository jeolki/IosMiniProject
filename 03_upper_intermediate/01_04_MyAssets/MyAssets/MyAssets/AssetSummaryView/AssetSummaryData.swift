//
//  AssetSummaryData.swift
//  MyAssets
//
//  Created by Jeonggi Hong on 2021/11/16.
//

import SwiftUI

class AssetSummaryData: ObservableObject {
    
    // 내보낼것
    @Published var assets: [Asset] = load("assets.json")
 
}

// 어떠한 파일을 입력하면 원하는 형태로 디코딩해주는 함수
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError(filename + "을 찾을 수 없습니다.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError(filename + "을 찾을 수 없습니다.")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError(filename + "을 \(T.self)로 파싱할 수 없습니다.")
    }
}
