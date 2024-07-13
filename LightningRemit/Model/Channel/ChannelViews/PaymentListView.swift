//
//  PaymentListView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 12/07/2024.
//

import SwiftUI
import LDKNode

struct PaymentsListView: View {
    @EnvironmentObject var viewModel: PaymentsListViewModel
    
    var body: some View {
        VStack {
            if viewModel.payments.isEmpty {
                Text("No Payments")
                    .font(.system(.caption, design: .monospaced))
                    .padding()
            } else {
                List {
                    ForEach(viewModel.payments, id: \.self) { payment in
                        VStack {
                            HStack(alignment: .center, spacing: 15) {
                                ZStack {
                                    switch payment.direction {
                                    case .inbound:
                                        Circle()
                                            .frame(width: 50.0, height: 50.0)
                                            .foregroundColor(.green)
                                        Image(systemName: "arrow.down")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .bold()
                                        
                                    case .outbound:
                                        Circle()
                                            .frame(width: 50.0, height: 50.0)
                                            .foregroundColor(.red)
                                        Image(systemName: "arrow.up")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .bold()
                                    }
                                }
                                VStack(alignment: .leading, spacing: 5.0) {
                                    HStack {
                                        let amountMsat = payment.amountMsat ?? 0
                                        let amountSats = amountMsat
                                        Text("\(amountSats) sats ")
                                            .font(.caption)
                                            .bold()
                                    }
                                    HStack {
                                        Text("Payment Hash")
                                        Text(payment.id)
                                            .truncationMode(.middle)
                                            .lineLimit(1)
                                            .foregroundColor(.primary)
                                    }
                                    .font(.caption)
                                    VStack {
                                        switch payment.status {
                                        case .pending:
                                            Text(payment.status.rawValue == "arrow.up" ? "pending" : "Sent")
                                                .font(.caption)
                                                .foregroundColor(.green)
                                        case .succeeded:
                                            Text(payment.status.rawValue == "arrow.down" ? "Sent" : "Received")
                                                .font(.caption)
                                                .foregroundColor(.green)
                                        case .failed:
                                            Text("Failed")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                Spacer()
                                
                                ZStack {
                                    Circle()
                                        .frame(width: 50.0, height: 50.0)
                                        .foregroundColor(.purple)
                                    Image(systemName: "bolt.fill")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.listPayments()
                    viewModel.addPayment(amountMsat: 4700, direction: .outbound, status: .pending)
                }
            }
        }
        .onAppear {
            viewModel.listPayments()
        }
    }
}

#Preview {
    PaymentsListView()
        .environmentObject(PaymentsListViewModel())
}
