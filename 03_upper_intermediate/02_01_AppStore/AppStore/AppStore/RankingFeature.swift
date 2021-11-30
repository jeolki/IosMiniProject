//
//  RankingFeature.swift
//  AppStore
//
//  Created by Jeonggi Hong on 2021/11/30.
//

import Foundation

struct RankingFeature: Decodable {
    let title: String
    let description: String
    let isInPurchaseApp: Bool
}
