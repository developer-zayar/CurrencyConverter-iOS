//
//  CurrencyUseCase.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 28/08/2025.
//

import Foundation

protocol CurrencyUseCaseDelegate: AnyObject {
    func getSupportedCurrencies() async throws -> [Currency]
    func getLatestRates(baseCurrency: String) async throws -> [String: Double]
    func convertCurrency(amount: Double, from: String, to: String) -> Double
    func swapCurrencies(from: Currency?, to: Currency?) -> (from: Currency?, to: Currency?)
}

class CurrencyUseCase: CurrencyUseCaseDelegate {
    private let repository: CurrencyRepositoryDelegate
    
    init(repository: CurrencyRepositoryDelegate = CurrencyRepository()) {
        self.repository = repository
    }
    
    func getSupportedCurrencies() async throws -> [Currency] {
        return try await repository.fetchSupportedCodes()
    }
    
    func getLatestRates(baseCurrency: String) async throws -> [String: Double] {
        let response = try await repository.fetchLatestRates()
        return response.conversionRates
    }
    
    func convertCurrency(amount: Double, from: String, to: String) -> Double {
        return 0.0
    }
    
    func swapCurrencies(from: Currency?, to: Currency?) -> (from: Currency?, to: Currency?) {
        return (from: to, to: from)
    }
}
