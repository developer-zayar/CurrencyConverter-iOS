//
//  CurrencyPickerView.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 15/08/2025.
//

import SwiftUI

struct CurrencyPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCurrency: Currency?
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List(getFilteredCurrency()) { currency in
                Button {
                    selectedCurrency = currency
                    dismiss()
                } label: {
                    HStack {
                        Text(currency.countryCode)
                            .font(.title)

                        Spacer().frame(width: 24)

                        VStack(alignment: .leading) {
                            Text(currency.name)
                                .font(.headline)

                            Text("\(currency.code) \(currency.symbol)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Select Currency")
            .searchable(text: $searchText, prompt: "Search")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    func getFilteredCurrency() -> [Currency] {
        if searchText.isEmpty {
            return dummyCurrencies
        } else {
            return dummyCurrencies.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                    $0.code.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

#Preview {
//    CurrencyPickerView(selectedCurrency: $Currency(code: "USD", name: "United States", symbol: "$"))
}
