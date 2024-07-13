//
//  CountryFlag.swift
//  LightningRemit
//
//  Created by Temiloluwa on 06/07/2024.
//

import Foundation

func flag(country: String) -> String {
    let base: UInt32 = 127397
    var flag = ""
    for v in country.unicodeScalars {
        flag.unicodeScalars.append(UnicodeScalar(base + v.value)!)
    }
    return flag
}

enum CurrencyCode: String {
    case USD
    case EUR
    case GBP
    case CAD
    case CHF
    case AUD
    case JPY
}
