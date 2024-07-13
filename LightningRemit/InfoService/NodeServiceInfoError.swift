//
//  NodeServiceInfoError.swift
//  LightningRemit
//
//  Created by Temiloluwa on 03/07/2024.
//

import Foundation
import LDKNode

enum NodeInfoServiceError: Error {
    case invalidURL
    case invalidServerResponse
}

enum LightningPaymentStatus {
    case pending
    case succeeded
    case failed
    
    init(_ paymentStatus: PaymentStatus) {
        switch paymentStatus {
        case .pending:
            self = .pending
        case .succeeded:
            self = .succeeded
        case .failed:
            self = .failed
        }
    }
}
