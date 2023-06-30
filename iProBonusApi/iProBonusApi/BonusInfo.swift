//
//  BonusInfo.swift
//  iProBonusApi
//
//  Created by Nataly on 30.06.2023.
//

import Foundation

struct BonusInfo: Codable {
    let resultOperation: BonusInfoResponseResult
    let data: BonusInfoResponseData
}

struct BonusInfoResponseResult: Codable { }

public struct BonusInfoResponseData: Codable {
    public let currentQuantity: Int
    public let forBurningQuantity: Int
    public let dateBurning: String
}
