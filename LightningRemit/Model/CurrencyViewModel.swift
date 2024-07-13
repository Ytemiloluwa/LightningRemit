//import Foundation
//import Combine

//class CurrencyViewModel: ObservableObject {
//    @Published var selectedCurrency: String = "USD"
//    @Published var satsBalance: UInt64 = 0
//    @Published var convertedAmount: Double = 0.0
//    
//    var conversionRates: [String: Double] = [:]
//    var currentLanguage: String = "en" // Default language, you can manage this based on your app's settings
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
//        
//        loadConversionRates()
//    }
//    
//    func loadConversionRates() {
//        
//        conversionRates = [
//            "USD": 0.00058,
//            "EUR": 0.0005,
//            "JPY": 0.0911,
//            "GBP": 0.000445,
//            "AUD": 0.000866,
//            "NGN": 0.824,
//            "CAD": 0.000787,
//            "CHF": 0.0005,
//            "CNY": 0.0042,
//            "SEK": 0.00021098,
//            "NZD": 0.000958,
//            "BRL": 0.003185,
//            "INR": 0.048208,
//            "MXN": 0.010337,
//            "ZAR": 0.010531,
//            "RUB": 0.0507,
//            "TRY": 0.0020456,
//            "KRW": 0.8066,
//            "THB": 0.0212,
//            "AED": 0.002121,
//            "SAR": 0.01052
//        ]
//    }
//    
//    // Method to get localized string based on current language
//    func localizedString(_ key: String) -> String {
//        // You can fetch the localized string from your .xcstrings or .strings file based on `currentLanguage`
//        return NSLocalizedString(key, tableName: nil, bundle: .main, value: "", comment: "")
//    }
//    
//    func convertToSelectedCurrency() {
//        guard let rate = conversionRates[selectedCurrency] else { return }
//        convertedAmount = Double(satsBalance) * rate
//    }
//}

import Foundation
import Combine

class CurrencyViewModel: ObservableObject {
    @Published var selectedCurrency: String = "USD"
    @Published var satsBalance: UInt64 = 0
    @Published var convertedAmount: Double = 0.0
    
    var conversionRates: [String: Double] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    // Mapping between country codes and languages
    
    let countryLanguageMapping: [String: String] = [
        "US": "en", "EU": "fr", "JP": "ja", "GB": "en", "AU": "en",
        "CA": "en", "CH": "de", "CN": "zh", "SE": "sv", "NZ": "en", "NG": "en",
        "BR": "pt", "IN": "hi", "MX": "es", "ZA": "af", "RU": "ru",
        "TR": "tr", "KR": "ko", "TH": "th", "AE": "ar", "SA": "ar"
    ]
    
    init() {
        loadConversionRates()
    }
    
    func loadConversionRates() {
        conversionRates = [
            "USD": 0.00058, "EUR": 0.0005, "JPY": 0.0911, "GBP": 0.000445,
            "AUD": 0.000866, "NGN": 0.824, "CAD": 0.000787, "CHF": 0.0005,
            "CNY": 0.0042, "SEK": 0.00021098, "NZD": 0.000958, "BRL": 0.003185,
            "INR": 0.048208, "MXN": 0.010337, "ZAR": 0.010531, "RUB": 0.0507,
            "TRY": 0.0020456, "KRW": 0.8066, "THB": 0.0212, "AED": 0.002121, "SAR": 0.01052
        ]
    }
    
    func convertToSelectedCurrency() {
        guard let rate = conversionRates[selectedCurrency] else { return }
        convertedAmount = Double(satsBalance) * rate
    }
    
    func localizedString(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}


