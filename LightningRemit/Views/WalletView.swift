//
//  HomeView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 04/07/2024.
//

import SwiftUI

struct WalletView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    @StateObject var currencyViewModel = CurrencyViewModel()
    @State private var isAnimating: Bool = false
    @State private var isCopied = false
    @State private var showCheckmark = false
    @StateObject private var paymentsListViewModel = PaymentsListViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 20 ){
                    
                    CurrencyView(viewModel: currencyViewModel)
                    
                    VStack(spacing: 20){
                        
                        
                        Text("Balance")
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                            .foregroundColor(.purple)
                            .scaleEffect(isAnimating ? 1.0 : 0.6)
                            .onAppear {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    isAnimating = true
                                }
                            }
                        withAnimation {
                            HStack(spacing: 15) {
                                Image(systemName: "bolt")
                                    .foregroundColor(.primary)
                                    .font(.title)
                                    .fontWeight(.thin)
                                Text(viewModel.totalBalance.formattedSatoshis())
                                    .contentTransition(.numericText())
                                    .fontWeight(.semibold)
                                    .fontDesign(.rounded)
                                    .redacted(
                                        reason: viewModel.isTotalBalanceFinished
                                        ? [] : .placeholder
                                    )
                                Text("sats")
                                    .foregroundColor(.primary)
                                    .fontWeight(.thin)
                            }
                            .font(.largeTitle)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        }
                        Text(formatCurrency (value: currencyViewModel.convertedAmount / 100_000_000, currencyCode: currencyViewModel.selectedCurrency))
                            .font(.title)
                            .bold()

                        HStack {
                            Text("Transactions")
                                .font(.title3)
                                .foregroundStyle(.purple)
                        }
                        PaymentsListView()
                            .environmentObject(paymentsListViewModel)
                    }

                    Spacer()
                }
                .onAppear {
                    Task {
                        viewModel.fetchBalances()
                        currencyViewModel.satsBalance = viewModel.totalBalance
                        viewModel.fetchOnchainPayments()
                    }
                }
            }
            .navigationTitle("Lightning Remit")
            
        }.navigationBarTitleDisplayMode(.automatic)
    }
}
#Preview {
    WalletView(viewModel: WalletViewModel())
        .environmentObject(LanguageManager.shared)
}
