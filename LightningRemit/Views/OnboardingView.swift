//
//  OnboardingView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 28/06/2024.
//

import BitcoinUI
import LDKNode
import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 25) {
                    Image(systemName: "bolt.circle.fill")
                        .resizable()
                        .foregroundColor(.purple)
                        .frame(width: 100, height: 100, alignment: .center)
                    Text("Lightning Remit")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                    Text("A simple bitcoin wallet for your enjoyment.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 25) {
                    Button(action: viewModel.createWallet) {
                        
                        Text("Create a new wallet address")
                        
                    }
                    .buttonStyle(BitcoinFilled(tintColor: .purple, isCapsule: true))
                }
                .padding(.top, 30)

                Spacer()

                VStack {
                    Text("Your wallet, your coins")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                    Text("100% open-source & open-design")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                .padding(EdgeInsets(top: 32, leading: 32, bottom: 8, trailing: 32))
            }
        }
        .onAppear {
            viewModel.restoreWallet()
        }
    }
}

#Preview("OnboardingView - en") {
    OnboardingView(viewModel: .init())
}

#Preview("OnboardingView - fr") {
    OnboardingView(viewModel: .init())
        .environment(\.locale, .init(identifier: "fr"))
}
