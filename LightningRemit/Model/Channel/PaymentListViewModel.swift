//
//  PaymentListViewModel.swift
//  LightningRemit
//
//  Created by Temiloluwa on 12/07/2024.
//

import Foundation
import SwiftUI
import LDKNode
import Combine

class PaymentsListViewModel: ObservableObject {
    @Published var payments: [Payment] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        generateRandomPayments()
    }
    
    private func generateRandomPayments() {
        let samplePayments = [
            Payment(id: UUID().uuidString, amountMsat: 1500, direction: .inbound, status: .succeeded),
            Payment(id: UUID().uuidString, amountMsat: 2300, direction: .outbound, status: .pending),
            Payment(id: UUID().uuidString, amountMsat: 4500, direction: .inbound, status: .succeeded),
            Payment(id: UUID().uuidString, amountMsat: 6700, direction: .inbound, status: .succeeded),
            Payment(id: UUID().uuidString, amountMsat: 9800, direction: .inbound, status: .succeeded),
        ]
        payments = samplePayments
    }
    
    func listPayments() {
        generateRandomPayments()
    }
    
    func addPayment(amountMsat: UInt64, direction: PaymentDirection, status: PaymentStatus) {
        let newPayment = Payment(id: UUID().uuidString, amountMsat: amountMsat, direction: direction, status: status)
        payments.insert(newPayment, at: 0)
    
    
    }
}


