//
//  CurrencyViewModel.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 28/08/2025.
//

import Alamofire
import Foundation

class CurrencyViewModel: ObservableObject {
    private static let baseURL = AppConfig.baseUrl + "/" + AppConfig.apiVersion + "/" + AppConfig.apiKey

    @Published var supportedCurrencies: [Currency] = []
    @Published var fromCurrency: Currency?
    @Published var toCurrency: Currency?
    var currencyRates = [String: Double]()

    func getCurrencyData() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        AF.request("\(Self.baseURL)/latest/USD")
            .responseDecodable(of: CurrencyReponse.self, decoder: decoder) { response in
                switch response.result {
                case .success(let currencies):
                    print("Successfully fetch currencies: \(currencies.conversionRates.count)")
                    self.currencyRates = currencies.conversionRates

                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }

    func getSupportedCodes() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        AF.request("https://v6.exchangerate-api.com/v6/1c2f03558dc36eaaf3bc7526/codes")
            .responseDecodable(of: CurrencyCodesResponse.self, decoder: decoder) { response in
                switch response.result {
                case .success(let codes):
                    print("Successfully fetch currencies: \(codes.supportedCodes.count)")
                    self.supportedCurrencies = codes.supportedCodes.map { countryCode in
                        Currency(code: countryCode[0], name: countryCode[1], symbol: nil, countryCode: nil)
                    }

                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
}
