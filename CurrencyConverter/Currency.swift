//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 14/08/2025.
//

import Foundation

struct Currency: Identifiable {
    let id = UUID()
    let code: String
    let name: String
    let symbol: String
    let countryCode: String
}

struct CurrencyReponse: Codable {
    let conversionRates: [String: Double]
}

let dummyCurrencies: [Currency] = [
    Currency(code: "USD", name: "United States", symbol: "$", countryCode: "US"),
    Currency(code: "MYR", name: "Malaysia", symbol: "RM", countryCode: "MY"),
    Currency(code: "SGD", name: "Singapore", symbol: "$", countryCode: "SG"),
    Currency(code: "VND", name: "Vietnam", symbol: "₫", countryCode: "VN"),
    Currency(code: "PHP", name: "Philippines", symbol: "₱", countryCode: "PH"),
    Currency(code: "MMK", name: "Myanmar", symbol: "Ks", countryCode: "MM"),
    Currency(code: "THB", name: "Thailand", symbol: "฿", countryCode: "TH"),
    Currency(code: "IDR", name: "Indonesia", symbol: "Rp", countryCode: "ID"),
    Currency(code: "JPY", name: "Japan", symbol: "¥", countryCode: "JP"),
    Currency(code: "CNY", name: "China", symbol: "¥", countryCode: "CN"),
    Currency(code: "KRW", name: "South Korea", symbol: "₩", countryCode: "KR"),
    Currency(code: "INR", name: "India", symbol: "₹", countryCode: "IN"),
]
