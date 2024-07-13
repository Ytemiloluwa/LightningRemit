//
//  InvoiceViewModel.swift
//  LightningRemit
//
//  Created by Temiloluwa on 09/07/2024.
//

import Foundation
import LDKNode
import SwiftUI

class InvoiceViewModel: ObservableObject {
    @Published var invoice: Bolt11Invoice = ""
    @Published var receiveViewError: LightningRemitError?
    @Published var networkColor = Color.gray
    @Published var expirySecs: Date?

    func receiveVariableAmountPayment(description: String, expirySecs: UInt32) async {
        do {
            let invoice = try await NodeService.shared.receiveVariableAmount(
                description: description,
                expirySecs: expirySecs
            )
            DispatchQueue.main.async {
                self.invoice = invoice
                self.expirySecs = Date().addingTimeInterval(TimeInterval(expirySecs))
            }
        } catch let error as NodeError {
            let errorString = handleNodeError(error)
            DispatchQueue.main.async {
                self.receiveViewError = .init(title: errorString.title, detail: errorString.detail)
            }
        } catch {
            DispatchQueue.main.async {
                self.receiveViewError = .init(
                    title: "Unexpected error",
                    detail: error.localizedDescription
                )
            }
        }
    }
}
