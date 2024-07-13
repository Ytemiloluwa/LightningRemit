//
//  CurrencyView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 06/07/2024.
//
import SwiftUI

struct CurrencyView: View {
    
    @StateObject var viewModel = CurrencyViewModel()
    let currencyData: [(code: String, country: String)] = [
        ("USD", "US"), ("EUR", "EU"), ("JPY", "JP"), ("GBP", "GB"), ("AUD", "AU"),
        ("CAD", "CA"), ("CHF", "CH"), ("CNY", "CN"), ("SEK", "SE"), ("NZD", "NZ"), ("NGN", "NG"),
        ("BRL", "BR"), ("INR", "IN"), ("MXN", "MX"), ("ZAR", "ZA"), ("RUB", "RU"),
        ("TRY", "TR"), ("KRW", "KR"), ("THB", "TH"), ("AED", "AE"), ("SAR", "SA")
    ]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Menu {
                    ForEach(currencyData, id: \.code) { currency in
                        Button(action: {
                            viewModel.selectedCurrency = currency.code
                            viewModel.convertToSelectedCurrency()
                            if let language = viewModel.countryLanguageMapping[currency.country] {
                                LanguageManager.shared.currentLanguage = language
                            }
                        }) {
                            HStack {
                                Text(flag(country: currency.country))
                                Text(currency.code)
                            }
                        }
                    }
                } label: {
                    HStack {
                        if let selectedCurrencyCountry = currencyData.first(where: { $0.code == viewModel.selectedCurrency })?.country {
                            Text(flag(country: selectedCurrencyCountry))
                                .font(.title)
                        }
                        Text(viewModel.localizedString(viewModel.selectedCurrency))
                            .font(.title)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding(.top, 16)
                .padding(.horizontal)
            }
            .padding(.top, 16)
            .padding(.horizontal)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("LanguageChanged"))) { _ in
            viewModel.objectWillChange.send()
        }
    }
    
    // Helper function to get flag emoji
    func flag(country: String) -> String {
        let base: UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView()
    }
}
