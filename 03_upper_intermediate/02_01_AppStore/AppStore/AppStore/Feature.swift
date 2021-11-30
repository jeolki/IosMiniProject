//
//  Feature.swift
//  AppStore
//
//  Created by Jeonggi Hong on 2021/11/30.
//

import Foundation

struct Feature: Decodable {
    let type: String
    let appName: String
    let description: String
    let imageURL: String
}
