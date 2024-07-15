//
//  CurrencyView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 06/07/2024.
//
import SwiftUI

struct CurrencyView: View {
    @StateObject var viewModel =  CurrencyViewModel()
    @EnvironmentObject var languageManager: LanguageManager
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
                            languageManager.currentLanguage = languageForCountry(currency.country)
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
                        Text(viewModel.selectedCurrency)
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
    
    // Helper function to map country code to language identifier
    func languageForCountry(_ country: String) -> String {
        switch country {
        case "US": return "en"
        case "EU": return "de"
        case "JP": return "ja"
        case "GB": return "en"
        case "AU": return "en"
        case "CA": return "en"
        case "CH": return "fr"
        case "CN": return "zh-Hans"
        case "SE": return "sv"
        case "NZ": return "en"
        case "NG": return "en"
        case "BR": return "pt"
        case "IN": return "hi"
        case "MX": return "es"
        case "ZA": return "af"
        case "RU": return "ru"
        case "TR": return "tr"
        case "KR": return "ko"
        case "TH": return "th"
        case "AE": return "ar"
        case "SA": return "ar"
        default: return "en"
        }
    }
}

#Preview {
    CurrencyView()
        .environmentObject(LanguageManager.shared)
}
