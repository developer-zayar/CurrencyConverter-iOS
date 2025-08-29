//
//  CurrencyRepository.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 28/08/2025.
//

import Alamofire
import Foundation

protocol CurrencyRepositoryDelegate: AnyObject {
    func fetchSupportedCodes() async throws -> [Currency]
    func fetchLatestRates() async throws -> CurrencyReponse
}

class CurrencyRepository: CurrencyRepositoryDelegate {
    private let baseURL = AppConfig.baseUrl + "/" + AppConfig.apiVersion + "/" + AppConfig.apiKey
    private let baseCurrency: String

    init(baseCurrency: String = "USD") {
        self.baseCurrency = baseCurrency
    }

    func fetchSupportedCodes() async throws -> [Currency] {
        let url = "\(baseURL)/codes"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .responseDecodable(of: CurrencyCodesResponse.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let codes):
                        let currencies = codes.supportedCodes.map {
                            Currency(code: $0[0], name: $0[1], symbol: nil, countryCode: nil)
                        }
                        continuation.resume(returning: currencies)

                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    func fetchLatestRates() async throws -> CurrencyReponse {
        let url = "\(baseURL)/latest/\(baseCurrency)"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .responseDecodable(of: CurrencyReponse.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let currencies):
                        continuation.resume(returning: currencies)

                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
