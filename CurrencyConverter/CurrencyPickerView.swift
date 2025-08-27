//
//  CurrencyPickerView.swift
//  CurrencyConverter
//
//  Created by Zay Yar Phyo on 15/08/2025.
//

import Alamofire
import SwiftUI

struct CurrencyPickerView: View {
    @Environment(\.dismiss) var dismiss
    var currencies: [Currency]
//    @Binding var selectedCurrency: Currency?
    var onSelectCurrency: ((Currency) -> Void)?

    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List(getFilteredCurrency()) { currency in
                Button {
//                    selectedCurrency = currency
                    onSelectCurrency?(currency)
                    dismiss()
                } label: {
                    HStack {
                        Text(currency.code)
                            .font(.title)
                            .frame(width: 80)

//                        Spacer().frame(width: 24)

                        VStack(alignment: .leading) {
                            Text(currency.name)
                                .font(.headline)

//                            Text("\(currency.code) \(currency.symbol)")
//                                .font(.subheadline)
//                                .foregroundColor(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Select Currency")
            .searchable(text: $searchText, prompt: "Search countries")
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
            return currencies
        }
        return currencies.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.code.lowercased().contains(searchText.lowercased())
        }
    }
}

#Preview {
    CurrencyPickerView(currencies: [.init(code: "USD", name: "United States", symbol: "$", countryCode: "US")])
}
