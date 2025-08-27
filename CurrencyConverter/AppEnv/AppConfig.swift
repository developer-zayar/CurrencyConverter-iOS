//
//  AppConfig.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 28/08/2025.
//

import Foundation

enum AppConfig {
    static var apiVersion: String {
        return "v6"
    }

    static var baseUrl: String {
        return configuration(key: .baseUrl)
    }

    static var apiKey: String {
        return configuration(key: .apiKey)
    }

    private static func configuration(key: Plist) -> String {
        if let infoDictionary = Bundle.main.infoDictionary {
            return infoDictionary[key.value] as? String ?? ""
        } else {
            fatalError("Unable to load plist file")
        }
    }
}
