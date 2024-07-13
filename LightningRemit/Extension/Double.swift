//
//  Double.swift
//  LightningRemit
//
//  Created by Temiloluwa on 09/07/2024.
//

import Foundation

extension Double {

    func formattedPrice(currencyCode: CurrencyCode) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = currencyCode.rawValue

        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    func valueInUSD(price: Double) -> String {
        let bitcoin = self / 100_000_000.0
        let usdValue = bitcoin * price
        let value = usdValue.formattedPrice(currencyCode: .USD)
        return value
    }

}
