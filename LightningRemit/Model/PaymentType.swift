//
//  Payment.swift
//  LightningRemit
//
//  Created by Temiloluwa on 05/07/2024.
//

import Foundation

enum PaymentType {
    case isLightning
    case isLightningURL
    case isBitcoin
    case isNone
}

enum PaymentDirection {
    case inbound
    case outbound
}

enum PaymentStatus: String {
    case pending
    case succeeded
    case failed
}

struct Payment: Identifiable, Hashable {
    var id: String
    var amountMsat: UInt64?
    var direction: PaymentDirection
    var status: PaymentStatus
}

