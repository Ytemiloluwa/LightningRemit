//
//  SendViewModel.swift
//  LightningRemit
//
//  Created by Temiloluwa on 07/07/2024.
//

import Foundation
import SwiftUI
import LDKNode
import BitcoinUI


@MainActor

class SendViewModel: ObservableObject {

    var networkColor = Color.blue
    var amountConfirmationViewError: LightningRemitError?
    @Published var sendConfirmationViewError: LightningRemitError?
    @Published var invoice: String = ""
    @Published var parseError: LightningRemitError?
    @Published var shouldNavigate: Bool = false
    @Published var paymentHash: PaymentHash?
    @Published var amount: String = ""
    
    init(amount: String, invoice: String) {
        
        self.amount = amount
        self.invoice = invoice
    }
    func sendToOnchain(address: String, amountMsat: UInt64) async {
        do {
            try await NodeService.shared.sendToAddress(
                address: address,
                amountMsat: amountMsat
              
            )
        } catch let error as NodeError {
            let errorString = handleNodeError(error)
            DispatchQueue.main.async {
                self.amountConfirmationViewError = .init(
                    title: errorString.title,
                    detail: errorString.detail
                )
            }
        } catch {
            DispatchQueue.main.async {
                self.amountConfirmationViewError = .init(
                    title: "Unexpected error",
                    detail: error.localizedDescription
                )
            }
        }
    }
    func sendPayment(invoice: String) async  {
        do {
            let paymentHash = try await NodeService.shared.send(bolt11Invoice: invoice)
            DispatchQueue.main.async {
                self.paymentHash = invoice
            }
        } catch let error as NodeError {
            let errorString = handleNodeError(error)
            DispatchQueue.main.async {
                self.sendConfirmationViewError = .init(title: errorString.title, detail: errorString.detail)
            }
        } catch {
            DispatchQueue.main.async {
                self.sendConfirmationViewError = .init(title: "Unexpected error", detail: error.localizedDescription)
            }
        }
    }

    func sendPaymentUsingAmount(invoice: Bolt11Invoice, amountMsat: UInt64) async {
        do {
            try await NodeService.shared.sendUsingAmount(
                bolt11Invoice: invoice,
                amountMsat: amountMsat
            )
        } catch let error as NodeError {
            NotificationCenter.default.post(name: .ldkErrorReceived, object: error)
            let errorString = handleNodeError(error)
            DispatchQueue.main.async {
                self.amountConfirmationViewError = .init(
                    title: errorString.title,
                    detail: errorString.detail
                )
            }
        } catch {
            DispatchQueue.main.async {
                self.amountConfirmationViewError = .init(
                    title: "Unexpected error",
                    detail: error.localizedDescription
                )
            }
        }
    }

    func sendPaymentBolt12(invoice: Bolt12Invoice) async {
        do {
            try await NodeService.shared.send(bolt12Invoice: invoice)
        } catch let error as NodeError {
            NotificationCenter.default.post(name: .ldkErrorReceived, object: error)
            let errorString = handleNodeError(error)
            DispatchQueue.main.async {
                self.amountConfirmationViewError = .init(
                    title: errorString.title,
                    detail: errorString.detail
                )
            }
        } catch {
            DispatchQueue.main.async {
                self.amountConfirmationViewError = .init(
                    title: "Unexpected error",
                    detail: error.localizedDescription
                )
            }
        }
    }

    func getColor() {
        let color = NodeService.shared.AppColor
        DispatchQueue.main.async {
            self.networkColor = color
        }
    }

    func handleLightningPayment(address: String, numpadAmount: String) async {
        if address.starts(with: "lno") {
            await sendPaymentBolt12(invoice: address)
        } else if address.bolt11amount() == "0" {
            if let amountSats = UInt64(numpadAmount) {
                let amountMsat = amountSats * 1000
                await sendPaymentUsingAmount(invoice: address, amountMsat: amountMsat)
            } else {
                self.amountConfirmationViewError = .init(
                    title: "Unexpected error",
                    detail: "Invalid amount entered"
                )
            }
        } else {
            await sendPayment(invoice: address)
        }
    }

    func handleBitcoinPayment(address: String, numpadAmount: String) async {
        if numpadAmount == "0" {
            self.amountConfirmationViewError = .init(
                title: "Unexpected error",
                detail: "Invalid amount entered"
            )
        } else if let amount = UInt64(numpadAmount) {
            await sendToOnchain(address: address, amountMsat: amount)
        } else {
            self.amountConfirmationViewError = .init(
                title: "Unexpected error",
                detail: "Unknown error occurred"
            )
        }
    }

    func handleLightningURLPayment() {
        self.amountConfirmationViewError = .init(
            title: "LNURL Error",
            detail: "LNURL not supported yet"
        )
    }

}
