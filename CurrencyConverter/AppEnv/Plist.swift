//
//  Plist.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 27/08/2025.
//

import Foundation

enum Plist {
    case baseUrl
    case apiKey
    var value: String {
        switch self {
        case .baseUrl:
            return "Base URL"
        case .apiKey:
            return "API Key"
        }
    }
}
