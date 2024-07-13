//
//  TransactionViewModel.swift
//  LightningRemit
//
//  Created by Temiloluwa on 10/07/2024.
//

import Foundation
import Combine
import LDKNode

class PaymentsViewModel: ObservableObject {
    @Published var payments: [PaymentDetails] = []

    func listPayments() {
        self.payments = NodeService.shared.listPayments()
    }
}

