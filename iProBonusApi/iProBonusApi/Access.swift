//
//  Access.swift
//  iProBonusApi
//
//  Created by Nataly on 30.06.2023.
//

import Foundation

struct Access: Codable {
    let result: AccessTokenResponseResult
    let accessToken: String
}

struct AccessTokenResponseResult: Codable { }
