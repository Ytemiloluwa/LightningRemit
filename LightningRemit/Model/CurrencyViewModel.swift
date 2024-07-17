import Foundation
import Combine

class CurrencyViewModel: ObservableObject {
    @Published var selectedCurrency: String = "USD"
    @Published var satsBalance: UInt64 = 0 {
        didSet {
            convertToSelectedCurrency()
        }
    }
    @Published var convertedAmount: Double = 0.0
    
    var conversionRates: [String: Double] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    // Mapping between country codes and languages
    let countryLanguageMapping: [String: String] = [
        "US": "en", "EU": "fr", "JP": "ja", "GB": "en", "AU": "en",
        "CA": "en", "CH": "de", "CN": "zh", "SE": "sv", "NZ": "en", "NG": "en",
        "BR": "pt", "IN": "hi", "MX": "es", "ZA": "af", "RU": "ru",
        "TR": "tr", "KR": "ko", "TH": "th", "AE": "ar", "SA": "ar",
        "FRA": "fr", "ESP": "es"
    ]
    
    init() {
        fetchConversionRates()
    }
    
    func fetchConversionRates() {
        let url = URL(string: "https://api.coingecko.com/api/v3/exchange_rates")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CoinGeckoResponse.self, decoder: JSONDecoder())
            .map { response in
                response.rates.mapValues { $0.value }
            }
            .replaceError(with: [:])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rates in
                self?.conversionRates = rates
                self?.convertToSelectedCurrency()
            }
            .store(in: &cancellables)
    }
    
    func convertToSelectedCurrency() {
        guard let rate = conversionRates[selectedCurrency.lowercased()] else { return }
        convertedAmount = Double(satsBalance) * rate
    }
    
    func localizedString(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}

struct CoinGeckoResponse: Decodable {
    let rates: [String: Rate]
    
    struct Rate: Decodable {
        let name: String
        let unit: String
        let value: Double
        let type: String
    }
}
