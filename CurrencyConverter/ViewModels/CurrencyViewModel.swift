//
//  CurrencyViewModel.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 28/08/2025.
//

import Alamofire
import Foundation

@MainActor
class CurrencyViewModel: ObservableObject {
    @Published var supportedCurrencies: [Currency] = []
    @Published var fromCurrency: Currency?
    @Published var toCurrency: Currency?
    @Published var amount: String = ""
    @Published var convertedAmount: String = ""

    var currencyRates = [String: Double]()

    private let useCase: CurrencyUseCaseDelegate

    init(useCase: CurrencyUseCaseDelegate = CurrencyUseCase()) {
        self.useCase = useCase
    }

    func getSupportedCurrencies() async {
        do {
            let currencies = try await useCase.getSupportedCurrencies()
            supportedCurrencies = currencies
            print("Supported Currencies: \(supportedCurrencies.count)")
        } catch {
            print("Error fetching supported currencies: \(error)")
        }
    }

    func getLatestRates() async {
        do {
            let latestRates = try await useCase.getLatestRates(baseCurrency: "USD")
            currencyRates = latestRates
            print("Latest Rates: \(currencyRates.count)")
        } catch {
            print("Error fetching latest rates: \(error)")
        }
    }

    func getConversionRate() {
        guard
            let fromCode = fromCurrency?.code,
            let toCode = toCurrency?.code,
            let amountDouble = Double(amount),
            currencyRates.isEmpty == false
        else {
            convertedAmount = ""
            return
        }

        let baseAmount = amountDouble / (currencyRates[fromCode] ?? 1.0)

        let result = baseAmount * (currencyRates[toCode] ?? 0.0)
        convertedAmount = String(format: "%.2f", result)

//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        AF.request("https://v6.exchangerate-api.com/v6/1c2f03558dc36eaaf3bc7526/pair/\(fromCode)/\(toCode)/\(amountDouble)")
//            .responseDecodable(of: ConversionResponse.self, decoder: decoder) { response in
//                switch response.result {
//                case .success(let rate):
//                    print("Successfully fetch rate: \(rate.conversionRate), result: \(rate.conversionResult ?? 0.0)")
//                    self.convertedAmount = String(format: "%.2f", rate.conversionResult ?? 0.0)
//
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            }
    }

    func swapCurrencies() {
        let temp = fromCurrency
        fromCurrency = toCurrency
        toCurrency = temp
    }

    func clearData() {
        fromCurrency = nil
        toCurrency = nil
        amount = ""
        convertedAmount = ""
    }
}
