//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 13/08/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var fromCurrency: Currency? = nil
    @State private var toCurrency: Currency? = nil
    @State private var amount: String = ""
    @State private var convertedAmount: String = ""

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
                            }) {
                                HStack {
                                    if let countryCode = fromCurrency?.countryCode {
                                        Text(countryCode)
                                            .font(.title)
                                    } else {
                                        Image(systemName: "globe")
                                    }

                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(fromCurrency?.code ?? "Select")

                                        if let symbol = fromCurrency?.symbol {
                                            Text(symbol)
                                        }
                                    }

                                    Image(systemName: "chevron.down")
                                }
                            }

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
                            }) {
                                HStack {
                                    if let countryCode = toCurrency?.countryCode {
                                        Text(countryCode)
                                            .font(.title)
                                    } else {
                                        Image(systemName: "globe")
                                    }

                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(toCurrency?.code ?? "Select")

                                        if let symbol = toCurrency?.symbol {
                                            Text(symbol)
                                        }
                                    }

                                    Image(systemName: "chevron.down")
                                }
                            }

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
                    CurrencyPickerView(selectedCurrency: $fromCurrency)
                }
                .sheet(isPresented: $showToSheet) {
                    CurrencyPickerView(selectedCurrency: $toCurrency)
                }
            }
        }
    }

    private func swapCurrencies() {
        let temp = fromCurrency
        fromCurrency = toCurrency
        toCurrency = temp
    }

    private func clearData() {
        fromCurrency = nil
        toCurrency = nil
        amount = ""
        convertedAmount = ""
    }
}

#Preview {
    ContentView()
}
