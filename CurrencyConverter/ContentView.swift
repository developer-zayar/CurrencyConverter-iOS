//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 13/08/2025.
//

import Alamofire
import SwiftUI

struct ContentView: View {
    @State private var amount: String = ""
    @State private var convertedAmount: String = ""

    private var viewModel = CurrencyViewModel()

    @State private var showFromSheet = false
    @State private var showToSheet = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.blue)

                    Text("Convert currencies in real-time")
                        .foregroundStyle(.secondary)

                    Spacer().frame(height: 24)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "arrow.up.circle")
                                .foregroundStyle(.secondary)
                            Text("From")
                                .foregroundStyle(.secondary)
                        }

                        HStack {
                            Button(action: {
                                showFromSheet.toggle()
                            }, label: {
                                HStack {
                                    if let countryCode = viewModel.fromCurrency?.countryCode {
                                        Text(countryCode)
                                            .font(.title)
                                    } else {
                                        Image(systemName: "globe")
                                    }

                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(viewModel.fromCurrency?.code ?? "Select")

                                        if let symbol = viewModel.fromCurrency?.symbol {
                                            Text(symbol)
                                        }
                                    }

                                    Image(systemName: "chevron.down")
                                }
                            })

                            Divider()

                            TextField("Enter Amount", text: $amount)
                                .keyboardType(.decimalPad)
                                .font(.title3)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )

                        Button(action: swapCurrencies) {
                            Image(systemName: "arrow.up.arrow.down.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()

                        HStack {
                            Image(systemName: "arrow.down.circle")
                                .foregroundStyle(.secondary)
                            Text("To")
                                .foregroundStyle(.secondary)
                        }
                        HStack {
                            Button(action: {
                                showToSheet.toggle()
                            }, label: {
                                HStack {
                                    if let countryCode = viewModel.toCurrency?.countryCode {
                                        Text(countryCode)
                                            .font(.title)
                                    } else {
                                        Image(systemName: "globe")
                                    }

                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(viewModel.toCurrency?.code ?? "Select")

                                        if let symbol = viewModel.toCurrency?.symbol {
                                            Text(symbol)
                                        }
                                    }

                                    Image(systemName: "chevron.down")
                                }
                            })

                            Divider()

                            TextField("Converted Amount", text: $convertedAmount)
                                .keyboardType(.decimalPad)
                                .font(.title3)
                                .disabled(true)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )
                    }
                }
                .padding()
                .navigationTitle("Currency Converter")
                .toolbar {
                    ToolbarItem {
                        Button("Clear") {
                            clearData()
                        }
                    }
                }
                .sheet(isPresented: $showFromSheet) {
                    CurrencyPickerView(currencies: viewModel.supportedCurrencies) { selectedCurrency in
                        viewModel.fromCurrency = selectedCurrency
                        getConversionRate()
                    }
                }
                .sheet(isPresented: $showToSheet) {
                    CurrencyPickerView(currencies: viewModel.supportedCurrencies) { selectedCurrency in
                        viewModel.toCurrency = selectedCurrency
                        getConversionRate()
                    }
                }
            }
            .task {
//                viewModel.getCurrencyData()
                viewModel.getSupportedCodes()
            }
        }
    }

    func getConversionRate() {
        guard
            let fromCode = viewModel.fromCurrency?.code,
            let toCode = viewModel.toCurrency?.code,
            let amountDouble = Double(amount)
        else {
            convertedAmount = ""
            return
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        AF.request("https://v6.exchangerate-api.com/v6/1c2f03558dc36eaaf3bc7526/pair/\(fromCode)/\(toCode)/\(amountDouble)")
            .responseDecodable(of: ConversionResponse.self, decoder: decoder) { response in
                switch response.result {
                case .success(let rate):
                    print("Successfully fetch rate: \(rate.conversionRate), result: \(rate.conversionResult ?? 0.0)")
                    convertedAmount = String(format: "%.2f", rate.conversionResult ?? 0.0)

                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }

    private func swapCurrencies() {
        let temp = viewModel.fromCurrency
        viewModel.fromCurrency = viewModel.toCurrency
        viewModel.toCurrency = temp
    }

    private func clearData() {
        viewModel.fromCurrency = nil
        viewModel.toCurrency = nil
        amount = ""
        convertedAmount = ""
    }
}

#Preview {
    ContentView()
}
