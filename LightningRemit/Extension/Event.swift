//
//  Event.swift
//  LightningRemit
//
//  Created by Temiloluwa on 05/07/2024.
//

import Foundation
import LDKNode
import SwiftUI


extension Event: CustomStringConvertible {

    public var description: String {

        switch self {

        case .paymentSuccessful(_, let paymentHash, _):
            return "Payment Successful \(paymentHash.truncated(toLength: 10))"

        case .paymentFailed(_, let paymentHash, let paymentFailureReason):
            return
                "Payment Failed \(paymentFailureReason.debugDescription) \(paymentHash.truncated(toLength: 10))"

        case .paymentReceived(_, _, let amountMsat):
            let formatted = amountMsat.formatted()
            return "Payment Received \(formatted) sats"

        case .channelPending(_, _, _, let counterpartyNodeId, _):
            return "Channel Pending \(counterpartyNodeId.truncated(toLength: 10))"

        case .channelReady(_, _, let counterpartyNodeId):
            return "Channel Ready \(counterpartyNodeId?.truncated(toLength: 10) ?? "")"

        case .channelClosed(_, _, let counterpartyNodeId, let reason):
            let debugReason = reason.debugDescription
            return
                "Channel Closed \(debugReason) \(counterpartyNodeId?.truncated(toLength: 10) ?? "")"

        case .paymentClaimable(
            let paymentId,
            let paymentHash,
            let claimableAmountMsat,
            let claimDeadline
        ):
            return "Payment Claimable \(paymentHash.truncated(toLength: 10))"

        }

    }

}

struct ChannelDetailsFormatted: Identifiable {
    let id = UUID()
    let name: String
    let value: String
    let isCopyable: Bool
    var isCopied: Bool = false
}


protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}
