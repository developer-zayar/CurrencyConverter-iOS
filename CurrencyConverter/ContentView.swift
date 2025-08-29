//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 13/08/2025.
//

import Alamofire
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CurrencyViewModel()

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

                            TextField("Enter Amount", text: $viewModel.amount)
                                .keyboardType(.decimalPad)
                                .font(.title3)
                                .submitLabel(.done)
                                .onSubmit {
                                    viewModel.getConversionRate()
                                }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )

                        Button(action: {
                            viewModel.swapCurrencies()
                        }, label: {
                            Image(systemName: "arrow.up.arrow.down.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        })
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

                            TextField("Converted Amount", text: $viewModel.convertedAmount)
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

                    Spacer().frame(height: 24)

                    Button {
                        viewModel.getConversionRate()
                    } label: {
                        Text("Convert")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .navigationTitle("Currency Converter")
                .toolbar {
                    ToolbarItem {
                        Button("Clear") {
                            viewModel.clearData()
                        }
                    }
                }
                .sheet(isPresented: $showFromSheet) {
                    CurrencyPickerView(currencies: viewModel.supportedCurrencies) { selectedCurrency in
                        viewModel.fromCurrency = selectedCurrency
                        viewModel.getConversionRate()
                    }
                }
                .sheet(isPresented: $showToSheet) {
                    CurrencyPickerView(currencies: viewModel.supportedCurrencies) { selectedCurrency in
                        viewModel.toCurrency = selectedCurrency
                        viewModel.getConversionRate()
                    }
                }
            }
            .task {
                await viewModel.getSupportedCurrencies()
                await viewModel.getLatestRates()
            }
        }
    }
}

#Preview {
    ContentView()
}
